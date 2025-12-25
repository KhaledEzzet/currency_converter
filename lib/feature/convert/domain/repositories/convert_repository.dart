import 'package:currency_converter/feature/convert/domain/entities/latest_rates.dart';

abstract interface class ConvertRepository {
  Future<LatestRates> fetchLatestRates({
    required String from,
    required List<String> to,
    double amount = 1,
  });

  Future<Map<String, String>> fetchCurrencies();
}
