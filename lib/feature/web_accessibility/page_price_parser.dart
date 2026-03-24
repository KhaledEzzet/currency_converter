enum PagePriceTooltipState {
  skipped,
  available,
  unavailable,
}

class DetectedPagePrice {
  const DetectedPagePrice({
    required this.rawText,
    required this.sourceCurrency,
    required this.amount,
  });

  final String rawText;
  final String sourceCurrency;
  final double amount;
}

class PagePriceTooltipResolution {
  const PagePriceTooltipResolution._({
    required this.state,
    required this.targetCurrency,
    this.convertedAmount,
  });

  const PagePriceTooltipResolution.skipped({
    required String targetCurrency,
  }) : this._(
          state: PagePriceTooltipState.skipped,
          targetCurrency: targetCurrency,
        );

  const PagePriceTooltipResolution.available({
    required String targetCurrency,
    required double convertedAmount,
  }) : this._(
          state: PagePriceTooltipState.available,
          targetCurrency: targetCurrency,
          convertedAmount: convertedAmount,
        );

  const PagePriceTooltipResolution.unavailable({
    required String targetCurrency,
  }) : this._(
          state: PagePriceTooltipState.unavailable,
          targetCurrency: targetCurrency,
        );

  final PagePriceTooltipState state;
  final String targetCurrency;
  final double? convertedAmount;
}

class PagePriceParser {
  const PagePriceParser();

  static final RegExp _isoPrefixPattern = RegExp(
    r'\b([A-Z]{3})\s*([0-9]+(?:[ ,][0-9]{3})*(?:[.,][0-9]+)?)\b',
  );
  static final RegExp _isoSuffixPattern = RegExp(
    r'\b([0-9]+(?:[ ,][0-9]{3})*(?:[.,][0-9]+)?)\s*([A-Z]{3})\b',
  );
  static final RegExp _symbolPrefixPattern = RegExp(
    r'(?<!\w)([$€£¥₹₽])\s*([0-9]+(?:[ ,][0-9]{3})*(?:[.,][0-9]+)?)',
  );
  static final RegExp _symbolSuffixPattern = RegExp(
    r'\b([0-9]+(?:[ ,][0-9]{3})*(?:[.,][0-9]+)?)\s*(zł|€|£|¥|₹|₽)\b',
  );

  static const Map<String, String> _prefixSymbolCurrencies = <String, String>{
    r'$': 'USD',
    '€': 'EUR',
    '£': 'GBP',
    '¥': 'JPY',
    '₹': 'INR',
    '₽': 'RUB',
  };
  static const Map<String, String> _suffixSymbolCurrencies = <String, String>{
    '€': 'EUR',
    '£': 'GBP',
    '¥': 'JPY',
    '₹': 'INR',
    '₽': 'RUB',
    'zł': 'PLN',
  };

  DetectedPagePrice? parseFirst(String text) {
    final normalizedText = text.trim();
    if (normalizedText.isEmpty) {
      return null;
    }

    final isoPrefix = _isoPrefixPattern.firstMatch(normalizedText);
    if (isoPrefix != null) {
      return _buildMatch(
        rawText: isoPrefix.group(0)!,
        currency: isoPrefix.group(1)!,
        rawAmount: isoPrefix.group(2)!,
      );
    }

    final isoSuffix = _isoSuffixPattern.firstMatch(normalizedText);
    if (isoSuffix != null) {
      return _buildMatch(
        rawText: isoSuffix.group(0)!,
        currency: isoSuffix.group(2)!,
        rawAmount: isoSuffix.group(1)!,
      );
    }

    final symbolPrefix = _symbolPrefixPattern.firstMatch(normalizedText);
    if (symbolPrefix != null) {
      final currency = _prefixSymbolCurrencies[symbolPrefix.group(1)!];
      if (currency != null) {
        return _buildMatch(
          rawText: symbolPrefix.group(0)!,
          currency: currency,
          rawAmount: symbolPrefix.group(2)!,
        );
      }
    }

    final symbolSuffix = _symbolSuffixPattern.firstMatch(normalizedText);
    if (symbolSuffix != null) {
      final currency = _suffixSymbolCurrencies[symbolSuffix.group(2)!];
      if (currency != null) {
        return _buildMatch(
          rawText: symbolSuffix.group(0)!,
          currency: currency,
          rawAmount: symbolSuffix.group(1)!,
        );
      }
    }

    return null;
  }

  PagePriceTooltipResolution resolveTooltip({
    required DetectedPagePrice price,
    required String targetCurrency,
    required Map<String, double> conversionRates,
  }) {
    if (price.sourceCurrency == targetCurrency) {
      return PagePriceTooltipResolution.skipped(
        targetCurrency: targetCurrency,
      );
    }

    final rate = conversionRates[price.sourceCurrency];
    if (rate == null) {
      return PagePriceTooltipResolution.unavailable(
        targetCurrency: targetCurrency,
      );
    }

    return PagePriceTooltipResolution.available(
      targetCurrency: targetCurrency,
      convertedAmount: price.amount * rate,
    );
  }

  DetectedPagePrice? _buildMatch({
    required String rawText,
    required String currency,
    required String rawAmount,
  }) {
    final amount = _parseAmount(rawAmount);
    if (amount == null) {
      return null;
    }

    return DetectedPagePrice(
      rawText: rawText,
      sourceCurrency: currency,
      amount: amount,
    );
  }

  double? _parseAmount(String rawAmount) {
    final compact = rawAmount.replaceAll(' ', '');
    if (compact.isEmpty) {
      return null;
    }

    final hasComma = compact.contains(',');
    final hasDot = compact.contains('.');

    if (hasComma && hasDot) {
      final lastComma = compact.lastIndexOf(',');
      final lastDot = compact.lastIndexOf('.');
      if (lastComma > lastDot) {
        return double.tryParse(
          compact.replaceAll('.', '').replaceAll(',', '.'),
        );
      }
      return double.tryParse(compact.replaceAll(',', ''));
    }

    if (hasComma) {
      final parts = compact.split(',');
      if (parts.length == 2 && parts.last.length <= 2) {
        return double.tryParse(compact.replaceAll(',', '.'));
      }
      return double.tryParse(compact.replaceAll(',', ''));
    }

    if (hasDot) {
      final parts = compact.split('.');
      if (parts.length == 2 && parts.last.length <= 2) {
        return double.tryParse(compact);
      }
      return double.tryParse(compact.replaceAll('.', ''));
    }

    return double.tryParse(compact);
  }
}
