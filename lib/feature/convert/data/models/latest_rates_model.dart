import 'package:currency_converter/feature/convert/domain/entities/latest_rates.dart';

class LatestRatesModel {
  const LatestRatesModel({
    required this.amount,
    required this.base,
    required this.date,
    required this.rates,
  });

  factory LatestRatesModel.fromJson(Map<String, dynamic> json) {
    final ratesMap = <String, double>{};
    final rawRates = json['rates'];
    if (rawRates is Map<String, dynamic>) {
      for (final entry in rawRates.entries) {
        final value = entry.value;
        if (value is num) {
          ratesMap[entry.key] = value.toDouble();
        }
      }
    }

    return LatestRatesModel(
      amount: (json['amount'] as num?)?.toDouble() ?? 1,
      base: json['base'] as String? ?? '',
      date: json['date'] as String? ?? '',
      rates: ratesMap,
    );
  }

  final double amount;
  final String base;
  final String date;
  final Map<String, double> rates;

  LatestRates toEntity() {
    return LatestRates(
      amount: amount,
      base: base,
      date: date,
      rates: rates,
    );
  }
}
