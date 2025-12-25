import 'package:currency_converter/core/clients/network/network_client.dart';
import 'package:currency_converter/feature/convert/data/models/latest_rates_model.dart';

abstract interface class ConvertRemoteDataSource {
  Future<LatestRatesModel> fetchLatestRates({
    required String from,
    required List<String> to,
    double amount = 1,
  });

  Future<Map<String, String>> fetchCurrencies();
}

class ConvertRemoteDataSourceImpl implements ConvertRemoteDataSource {
  ConvertRemoteDataSourceImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  final NetworkClient _networkClient;

  @override
  Future<LatestRatesModel> fetchLatestRates({
    required String from,
    required List<String> to,
    double amount = 1,
  }) async {
    final response = await _networkClient.get<Map<String, dynamic>>(
      '/latest',
      queryParameters: <String, dynamic>{
        'from': from,
        if (to.isNotEmpty) 'to': to.join(','),
        'amount': amount,
      },
    );

    final data = response.data ?? <String, dynamic>{};
    return LatestRatesModel.fromJson(data);
  }

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
}
