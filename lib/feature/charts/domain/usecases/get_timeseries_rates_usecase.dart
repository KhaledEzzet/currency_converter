import 'package:currency_converter/feature/charts/domain/entities/timeseries_rates.dart';
import 'package:currency_converter/feature/charts/domain/repositories/charts_repository.dart';

class GetTimeseriesRatesUseCase {
  const GetTimeseriesRatesUseCase({required ChartsRepository repository})
      : _repository = repository;

  final ChartsRepository _repository;

  Future<TimeseriesRates> call({
    required DateTime startDate,
    required DateTime endDate,
    required String from,
    required String to,
  }) {
    return _repository.fetchTimeseries(
      startDate: startDate,
      endDate: endDate,
      from: from,
      to: to,
    );
  }
}
