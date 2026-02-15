import 'package:currency_converter/feature/charts/domain/entities/timeseries_rates.dart';

class TimeseriesRatesModel {
  const TimeseriesRatesModel({
    required this.base,
    required this.startDate,
    required this.endDate,
    required this.rates,
  });

  factory TimeseriesRatesModel.fromJson(
    Map<String, dynamic> json, {
    required String target,
  }) {
    final ratesMap = <DateTime, double>{};
    final rawRates = json['rates'];
    if (rawRates is Map<String, dynamic>) {
      for (final entry in rawRates.entries) {
        final date = DateTime.tryParse(entry.key);
        final rawValue = entry.value;
        if (date == null || rawValue is! Map<String, dynamic>) {
          continue;
        }
        final value = rawValue[target];
        if (value is num) {
          ratesMap[date] = value.toDouble();
        }
      }
    }

    return TimeseriesRatesModel(
      base: json['base'] as String? ?? '',
      startDate: DateTime.tryParse(json['start_date'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      endDate: DateTime.tryParse(json['end_date'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      rates: ratesMap,
    );
  }

  final String base;
  final DateTime startDate;
  final DateTime endDate;
  final Map<DateTime, double> rates;

  TimeseriesRates toEntity() {
    return TimeseriesRates(
      base: base,
      startDate: startDate,
      endDate: endDate,
      rates: rates,
    );
  }
}
