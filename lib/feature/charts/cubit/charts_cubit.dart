import 'package:flutter_bloc/flutter_bloc.dart';

import 'charts_state.dart';

class ChartsCubit extends Cubit<ChartsState> {
  ChartsCubit() : super(ChartsState.initial());

  void updateFromCurrency(String? currency) {
    if (currency == null) {
      return;
    }
    _emitUpdated(
      fromCurrency: currency,
      toCurrency: _resolveToCurrency(currency, state.toCurrency),
    );
  }

  void updateToCurrency(String? currency) {
    if (currency == null) {
      return;
    }
    _emitUpdated(toCurrency: currency);
  }

  void swapCurrencies() {
    _emitUpdated(
      fromCurrency: state.toCurrency,
      toCurrency: state.fromCurrency,
    );
  }

  void updateRange(String range) {
    _emitUpdated(selectedRange: range);
  }

  void _emitUpdated({
    String? fromCurrency,
    String? toCurrency,
    String? selectedRange,
  }) {
    final updatedFrom = fromCurrency ?? state.fromCurrency;
    final updatedTo = toCurrency ?? state.toCurrency;
    final updatedRange = selectedRange ?? state.selectedRange;
    final rate = _rateForPair(updatedFrom, updatedTo);
    final chartPoints = _buildChartPoints(rate, updatedRange);

    emit(
      state.copyWith(
        status: ChartsStatus.updated,
        fromCurrency: updatedFrom,
        toCurrency: updatedTo,
        selectedRange: updatedRange,
        rate: rate,
        chartPoints: chartPoints,
      ),
    );
  }

  double _rateForPair(String fromCurrency, String toCurrency) {
    final rateFrom = state.currencyRates[fromCurrency] ?? 1;
    final rateTo = state.currencyRates[toCurrency] ?? 1;
    if (rateFrom == 0) {
      return 0;
    }
    return rateTo / rateFrom;
  }

  List<ChartsPoint> _buildChartPoints(double baseRate, String range) {
    final offsets = ChartsState.rangeOffsets(range);
    return List<ChartsPoint>.generate(
      offsets.length,
      (index) => ChartsPoint(index, baseRate * (1 + offsets[index])),
    );
  }

  String _resolveToCurrency(String fromCurrency, String currentTo) {
    if (currentTo != fromCurrency) {
      return currentTo;
    }

    return state.currencies.firstWhere(
      (currency) => currency != fromCurrency,
      orElse: () => fromCurrency,
    );
  }
}
