import 'package:currency_converter/feature/convert/domain/repositories/convert_repository.dart';

class GetCurrenciesUseCase {
  const GetCurrenciesUseCase({required ConvertRepository repository})
      : _repository = repository;

  final ConvertRepository _repository;

  Future<Map<String, String>> call() {
    return _repository.fetchCurrencies();
  }
}
