import 'package:currency_converter/feature/convert/cubit/convert_state.dart';
import 'package:currency_converter/feature/convert/view/widgets/currency_flag.dart';
import 'package:flutter/material.dart';

class ConversionCard extends StatelessWidget {
  const ConversionCard({
    required this.state,
    required this.currency,
    required this.showCurrencyFlags,
    required this.useCurrencySymbols,
    super.key,
  });

  final ConvertState state;
  final String currency;
  final bool showCurrencyFlags;
  final bool useCurrencySymbols;

  @override
  Widget build(BuildContext context) {
    final converted = state.convertedAmounts[currency];
    final convertedText =
        converted == null ? '--' : converted.toStringAsFixed(2);
    final targetSymbol =
        useCurrencySymbols ? state.currencySymbols[currency] ?? '' : '';
    final displayValue =
        targetSymbol.isEmpty ? convertedText : '$targetSymbol $convertedText';
    final rateValue = state.currencyRates[currency]?.toStringAsFixed(4);
    final rateText = rateValue == null
        ? ''
        : '1 ${state.fromCurrency} = $rateValue $currency';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (showCurrencyFlags) ...[
              CurrencyFlag(code: state.currencyFlags[currency]),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                currency,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  displayValue,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (rateText.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    rateText,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
            // const SizedBox(width: 8),
            // const Icon(Icons.drag_handle, size: 18),
          ],
        ),
      ),
    );
  }
}
