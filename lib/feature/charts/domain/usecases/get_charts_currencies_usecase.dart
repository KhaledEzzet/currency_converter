import 'package:currency_converter/feature/charts/domain/repositories/charts_repository.dart';

class GetChartsCurrenciesUseCase {
  const GetChartsCurrenciesUseCase({required ChartsRepository repository})
      : _repository = repository;

  final ChartsRepository _repository;

  Future<Map<String, String>> call() {
    return _repository.fetchCurrencies();
  }
}
