import 'package:currency_converter/feature/charts/domain/entities/timeseries_rates.dart';

abstract interface class ChartsRepository {
  Future<Map<String, String>> fetchCurrencies();

  Future<TimeseriesRates> fetchTimeseries({
    required DateTime startDate,
    required DateTime endDate,
    required String from,
    required String to,
  });
}
