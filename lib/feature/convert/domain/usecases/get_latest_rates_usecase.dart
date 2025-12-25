import 'package:currency_converter/feature/convert/domain/entities/latest_rates.dart';
import 'package:currency_converter/feature/convert/domain/repositories/convert_repository.dart';

class GetLatestRatesUseCase {
  const GetLatestRatesUseCase({required ConvertRepository repository})
      : _repository = repository;

  final ConvertRepository _repository;

  Future<LatestRates> call({
    required String from,
    required List<String> to,
    double amount = 1,
  }) {
    return _repository.fetchLatestRates(
      from: from,
      to: to,
      amount: amount,
    );
  }
}
