import 'package:currency_converter/feature/charts/cubit/charts_state.dart';
import 'package:currency_converter/feature/charts/domain/entities/timeseries_rates.dart';
import 'package:currency_converter/feature/charts/domain/usecases/get_charts_currencies_usecase.dart';
import 'package:currency_converter/feature/charts/domain/usecases/get_timeseries_rates_usecase.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ChartsCubit extends Cubit<ChartsState> {
  ChartsCubit({
    required GetChartsCurrenciesUseCase getChartsCurrenciesUseCase,
    required GetTimeseriesRatesUseCase getTimeseriesRatesUseCase,
  })  : _getChartsCurrenciesUseCase = getChartsCurrenciesUseCase,
        _getTimeseriesRatesUseCase = getTimeseriesRatesUseCase,
        super(ChartsState.initial());

  final GetChartsCurrenciesUseCase _getChartsCurrenciesUseCase;
  final GetTimeseriesRatesUseCase _getTimeseriesRatesUseCase;
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  Future<void> initialize() async {
    emit(state.copyWith(status: ChartsStatus.loading, errorMessage: null));
    await _loadData(refreshCurrencies: true);
  }

  void syncFormFields() {
    final formState = formKey.currentState;
    if (formState == null) {
      return;
    }

    final fromField = formState.fields['chart_from_currency'];
    if (fromField?.value != state.fromCurrency) {
      fromField?.didChange(state.fromCurrency);
    }

    final toField = formState.fields['chart_to_currency'];
    if (toField?.value != state.toCurrency) {
      toField?.didChange(state.toCurrency);
    }
  }

  Future<void> updateFromCurrency(String? currency) async {
    if (currency == null) {
      return;
    }
    emit(state.copyWith(status: ChartsStatus.loading, errorMessage: null));
    await _loadData(
      fromCurrency: currency,
      toCurrency: state.toCurrency,
    );
  }

  Future<void> updateToCurrency(String? currency) async {
    if (currency == null) {
      return;
    }
    emit(state.copyWith(status: ChartsStatus.loading, errorMessage: null));
    await _loadData(toCurrency: currency);
  }

  Future<void> swapCurrencies() async {
    emit(state.copyWith(status: ChartsStatus.loading, errorMessage: null));
    await _loadData(
      fromCurrency: state.toCurrency,
      toCurrency: state.fromCurrency,
    );
  }

  Future<void> updateRange(String range) async {
    emit(state.copyWith(status: ChartsStatus.loading, errorMessage: null));
    await _loadData(selectedRange: range);
  }

  Future<void> _loadData({
    String? fromCurrency,
    String? toCurrency,
    String? selectedRange,
    bool refreshCurrencies = false,
  }) async {
    try {
      final shouldRefresh = refreshCurrencies || state.currencies.isEmpty;
      final currencies =
          shouldRefresh ? await _fetchCurrencies() : state.currencies;
      if (currencies.isEmpty) {
        emit(
          state.copyWith(
            status: ChartsStatus.failure,
            errorMessage: 'No currencies available.',
          ),
        );
        return;
      }

      final resolvedFrom =
          _resolveFromCurrency(currencies, fromCurrency ?? state.fromCurrency);
      final resolvedTo =
          _resolveToCurrency(resolvedFrom, toCurrency ?? state.toCurrency, currencies);
      final range = selectedRange ?? state.selectedRange;
      final endDate = DateTime.now();
      final startDate = _rangeStartDate(endDate, range);
      final timeseries = await _getTimeseriesRatesUseCase(
        startDate: startDate,
        endDate: endDate,
        from: resolvedFrom,
        to: resolvedTo,
      );
      final chartPoints = _mapToChartPoints(timeseries);
      final rate = chartPoints.isNotEmpty ? chartPoints.last.value : 0.0;
      final (changeValue, changePercent) = _calculateChange(chartPoints);
      final (minValue, maxValue, yInterval) =
          ChartsState.calculateStats(chartPoints);
      final currencyFlags = _buildCurrencyFlags(currencies);

      emit(
        state.copyWith(
          status: ChartsStatus.success,
          currencies: currencies,
          currencyFlags: currencyFlags,
          fromCurrency: resolvedFrom,
          toCurrency: resolvedTo,
          selectedRange: range,
          rate: rate,
          changeValue: changeValue,
          changePercent: changePercent,
          chartPoints: chartPoints,
          minValue: minValue,
          maxValue: maxValue,
          yInterval: yInterval,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ChartsStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<List<String>> _fetchCurrencies() async {
    final result = await _getChartsCurrenciesUseCase();
    final codes = result.keys.toList()..sort();
    return codes;
  }

  String _resolveFromCurrency(List<String> currencies, String fromCurrency) {
    if (currencies.contains(fromCurrency)) {
      return fromCurrency;
    }
    return currencies.first;
  }

  String _resolveToCurrency(
    String fromCurrency,
    String currentTo,
    List<String> currencies,
  ) {
    if (currentTo.isNotEmpty && currentTo != fromCurrency) {
      return currentTo;
    }
    return currencies.firstWhere(
      (currency) => currency != fromCurrency,
      orElse: () => fromCurrency,
    );
  }

  List<ChartsPoint> _mapToChartPoints(TimeseriesRates timeseries) {
    final entries = timeseries.rates.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return List<ChartsPoint>.generate(
      entries.length,
      (index) => ChartsPoint(index, entries[index].value),
    );
  }

  (double changeValue, double changePercent) _calculateChange(
    List<ChartsPoint> points,
  ) {
    if (points.length < 2) {
      return (0.0, 0.0);
    }
    final first = points.first.value;
    final last = points.last.value;
    final changeValue = last - first;
    final changePercent = first == 0 ? 0.0 : (changeValue / first) * 100;
    return (changeValue, changePercent);
  }

  DateTime _rangeStartDate(DateTime endDate, String range) {
    switch (range) {
      case '1M':
        return _subtractMonths(endDate, 1);
      case '3M':
        return _subtractMonths(endDate, 3);
      case '1Y':
        return DateTime(endDate.year - 1, endDate.month, endDate.day);
      case '5Y':
        return DateTime(endDate.year - 5, endDate.month, endDate.day);
      case '10Y':
        return DateTime(endDate.year - 10, endDate.month, endDate.day);
      case '1W':
      default:
        return endDate.subtract(const Duration(days: 7));
    }
  }

  DateTime _subtractMonths(DateTime date, int months) {
    var year = date.year;
    var month = date.month - months;
    while (month <= 0) {
      month += 12;
      year -= 1;
    }
    final day = date.day;
    final lastDayOfMonth = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, day > lastDayOfMonth ? lastDayOfMonth : day);
  }

  Map<String, String> _buildCurrencyFlags(List<String> currencies) {
    final flags = <String, String>{};
    for (final currency in currencies) {
      final code = _flagCodeForCurrency(currency);
      if (code.isNotEmpty) {
        flags[currency] = code;
      }
    }
    return flags;
  }

  String _flagCodeForCurrency(String currency) {
    if (currency == 'EUR') {
      return 'eu';
    }
    if (currency.length < 2) {
      return '';
    }
    return currency.substring(0, 2).toLowerCase();
  }
}
