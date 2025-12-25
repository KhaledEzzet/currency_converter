import 'dart:io';

import 'package:currency_converter/feature/convert/cubit/convert_cubit.dart';
import 'package:currency_converter/feature/convert/domain/entities/latest_rates.dart';
import 'package:currency_converter/feature/convert/domain/repositories/convert_repository.dart';
import 'package:currency_converter/feature/convert/domain/usecases/get_currencies_usecase.dart';
import 'package:currency_converter/feature/convert/domain/usecases/get_latest_rates_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class FakeConvertRepository implements ConvertRepository {
  FakeConvertRepository({
    required this.currencies,
    required this.latestRates,
  });

  final Map<String, String> currencies;
  final LatestRates latestRates;

  @override
  Future<Map<String, String>> fetchCurrencies() async => currencies;

  @override
  Future<LatestRates> fetchLatestRates({
    required String from,
    required List<String> to,
    double amount = 1,
  }) async {
    return latestRates;
  }
}

void main() {
  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('hydrated_bloc_test');
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: dir,
    );
  });

  test('ConvertCubit initializes with API currencies and rates', () async {
    final repository = FakeConvertRepository(
      currencies: <String, String>{
        'USD': 'United States Dollar',
        'EUR': 'Euro',
        'GBP': 'British Pound',
      },
      latestRates: const LatestRates(
        amount: 1,
        base: 'USD',
        date: '2024-01-01',
        rates: <String, double>{
          'EUR': 0.9,
          'GBP': 0.8,
        },
      ),
    );
    final cubit = ConvertCubit(
      getLatestRatesUseCase: GetLatestRatesUseCase(repository: repository),
      getCurrenciesUseCase: GetCurrenciesUseCase(repository: repository),
    );

    await cubit.initialize();

    expect(cubit.state.currencies, equals(<String>['EUR', 'GBP', 'USD']));
    expect(cubit.state.currencyRates['EUR'], 0.9);
    expect(cubit.state.currencySymbols['EUR'], '€');
    expect(cubit.state.currencyFlags['USD'], 'us');

    await cubit.close();
  });
}
