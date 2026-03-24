import 'package:currency_converter/feature/web_accessibility/page_price_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const parser = PagePriceParser();

  test('parses ISO code prices', () {
    final detectedPrice = parser.parseFirst('USD 120');

    expect(detectedPrice, isNotNull);
    expect(detectedPrice?.sourceCurrency, 'USD');
    expect(detectedPrice?.amount, 120);
  });

  test('parses symbol-based prices', () {
    final detectedPrice = parser.parseFirst('Special offer: €19.99');

    expect(detectedPrice, isNotNull);
    expect(detectedPrice?.sourceCurrency, 'EUR');
    expect(detectedPrice?.amount, 19.99);
  });

  test('maps bare dollar prices to USD', () {
    final detectedPrice = parser.parseFirst(r'$42.50');

    expect(detectedPrice, isNotNull);
    expect(detectedPrice?.sourceCurrency, 'USD');
    expect(detectedPrice?.amount, 42.5);
  });

  test('maps bare yen prices to JPY', () {
    final detectedPrice = parser.parseFirst('¥1200');

    expect(detectedPrice, isNotNull);
    expect(detectedPrice?.sourceCurrency, 'JPY');
    expect(detectedPrice?.amount, 1200);
  });

  test('skips tooltips when the source and target currencies match', () {
    final resolution = parser.resolveTooltip(
      price: const DetectedPagePrice(
        rawText: 'USD 10',
        sourceCurrency: 'USD',
        amount: 10,
      ),
      targetCurrency: 'USD',
      conversionRates: const <String, double>{'USD': 1},
    );

    expect(resolution.state, PagePriceTooltipState.skipped);
  });

  test('marks tooltip state unavailable when no rate is present', () {
    final resolution = parser.resolveTooltip(
      price: const DetectedPagePrice(
        rawText: 'GBP 10',
        sourceCurrency: 'GBP',
        amount: 10,
      ),
      targetCurrency: 'USD',
      conversionRates: const <String, double>{},
    );

    expect(resolution.state, PagePriceTooltipState.unavailable);
  });
}
