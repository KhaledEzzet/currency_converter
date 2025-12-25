import 'package:currency_converter/core/clients/network/network_client.dart';
import 'package:currency_converter/feature/charts/data/models/timeseries_rates_model.dart';
import 'package:intl/intl.dart';

abstract interface class ChartsRemoteDataSource {
  Future<Map<String, String>> fetchCurrencies();

  Future<TimeseriesRatesModel> fetchTimeseries({
    required DateTime startDate,
    required DateTime endDate,
    required String from,
    required String to,
  });
}

class ChartsRemoteDataSourceImpl implements ChartsRemoteDataSource {
  ChartsRemoteDataSourceImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  final NetworkClient _networkClient;

  @override
  Future<Map<String, String>> fetchCurrencies() async {
    final response = await _networkClient.get<Map<String, dynamic>>(
      '/currencies',
    );
    final data = response.data ?? <String, dynamic>{};
    final currencies = <String, String>{};
    for (final entry in data.entries) {
      final value = entry.value;
      if (value is String) {
        currencies[entry.key] = value;
      }
    }
    return currencies;
  }

  @override
  Future<TimeseriesRatesModel> fetchTimeseries({
    required DateTime startDate,
    required DateTime endDate,
    required String from,
    required String to,
  }) async {
    final formatter = DateFormat('yyyy-MM-dd');
    final start = formatter.format(startDate);
    final end = formatter.format(endDate);
    final response = await _networkClient.get<Map<String, dynamic>>(
      '/$start..$end',
      queryParameters: <String, dynamic>{
        'from': from,
        'to': to,
      },
    );
    final data = response.data ?? <String, dynamic>{};
    return TimeseriesRatesModel.fromJson(data, target: to);
  }
}
