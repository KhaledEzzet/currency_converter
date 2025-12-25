import 'package:currency_converter/feature/charts/data/datasources/charts_remote_data_source.dart';
import 'package:currency_converter/feature/charts/domain/entities/timeseries_rates.dart';
import 'package:currency_converter/feature/charts/domain/repositories/charts_repository.dart';

class ChartsRepositoryImpl implements ChartsRepository {
  ChartsRepositoryImpl({required ChartsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final ChartsRemoteDataSource _remoteDataSource;

  @override
  Future<Map<String, String>> fetchCurrencies() {
    return _remoteDataSource.fetchCurrencies();
  }

  @override
  Future<TimeseriesRates> fetchTimeseries({
    required DateTime startDate,
    required DateTime endDate,
    required String from,
    required String to,
  }) async {
    final result = await _remoteDataSource.fetchTimeseries(
      startDate: startDate,
      endDate: endDate,
      from: from,
      to: to,
    );
    return result.toEntity();
  }
}
