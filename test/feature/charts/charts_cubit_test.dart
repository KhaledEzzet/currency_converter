import 'package:currency_converter/feature/charts/cubit/charts_cubit.dart';
import 'package:currency_converter/feature/charts/domain/entities/timeseries_rates.dart';
import 'package:currency_converter/feature/charts/domain/repositories/charts_repository.dart';
import 'package:currency_converter/feature/charts/domain/usecases/get_charts_currencies_usecase.dart';
import 'package:currency_converter/feature/charts/domain/usecases/get_timeseries_rates_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeChartsRepository implements ChartsRepository {
  FakeChartsRepository({
    required this.currencies,
    required this.timeseries,
  });

  final Map<String, String> currencies;
  final TimeseriesRates timeseries;

  String? lastFrom;
  String? lastTo;

  @override
  Future<Map<String, String>> fetchCurrencies() async => currencies;

  @override
  Future<TimeseriesRates> fetchTimeseries({
    required DateTime startDate,
    required DateTime endDate,
    required String from,
    required String to,
  }) async {
    lastFrom = from;
    lastTo = to;
    return timeseries;
  }
}

void main() {
  test('ChartsCubit initializes with timeseries data', () async {
    final repository = FakeChartsRepository(
      currencies: <String, String>{
        'USD': 'United States Dollar',
        'EUR': 'Euro',
      },
      timeseries: TimeseriesRates(
        base: 'USD',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 2),
        rates: <DateTime, double>{
          DateTime(2024, 1, 1): 0.9,
          DateTime(2024, 1, 2): 1.0,
        },
      ),
    );
    final cubit = ChartsCubit(
      getChartsCurrenciesUseCase: GetChartsCurrenciesUseCase(
        repository: repository,
      ),
      getTimeseriesRatesUseCase: GetTimeseriesRatesUseCase(
        repository: repository,
      ),
    );

    await cubit.initialize();

    expect(cubit.state.currencies, equals(<String>['EUR', 'USD']));
    expect(cubit.state.fromCurrency, 'EUR');
    expect(cubit.state.toCurrency, 'USD');
    expect(cubit.state.rate, 1.0);
    expect(cubit.state.changeValue, closeTo(0.1, 0.0001));
    expect(cubit.state.changePercent, closeTo(11.1111, 0.01));
    expect(repository.lastFrom, cubit.state.fromCurrency);
    expect(repository.lastTo, cubit.state.toCurrency);

    await cubit.close();
  });
}
