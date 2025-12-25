import 'package:currency_converter/feature/convert/data/datasources/convert_remote_data_source.dart';
import 'package:currency_converter/feature/convert/domain/entities/latest_rates.dart';
import 'package:currency_converter/feature/convert/domain/repositories/convert_repository.dart';

class ConvertRepositoryImpl implements ConvertRepository {
  ConvertRepositoryImpl({required ConvertRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final ConvertRemoteDataSource _remoteDataSource;

  @override
  Future<LatestRates> fetchLatestRates({
    required String from,
    required List<String> to,
    double amount = 1,
  }) async {
    final result = await _remoteDataSource.fetchLatestRates(
      from: from,
      to: to,
      amount: amount,
    );
    return result.toEntity();
  }

  @override
  Future<Map<String, String>> fetchCurrencies() {
    return _remoteDataSource.fetchCurrencies();
  }
}
