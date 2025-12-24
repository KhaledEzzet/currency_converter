import 'package:flutter_bloc/flutter_bloc.dart';

import 'convert_state.dart';

class ConvertCubit extends Cubit<ConvertState> {
  ConvertCubit() : super(ConvertState.initial());

  void updateFromCurrency(String? currency) {
    final selectedCurrency = currency ?? state.fromCurrency;
    emit(
      state.copyWith(
        status: ConvertStatus.updated,
        fromCurrency: selectedCurrency,
        convertedAmounts: _calculateConversions(
          amountText: state.amountText,
          fromCurrency: selectedCurrency,
        ),
      ),
    );
  }

  void updateAmount(String amountText) {
    emit(
      state.copyWith(
        status: ConvertStatus.updated,
        amountText: amountText,
        convertedAmounts: _calculateConversions(
          amountText: amountText,
          fromCurrency: state.fromCurrency,
        ),
      ),
    );
  }

  Map<String, double> _calculateConversions({
    required String amountText,
    required String? fromCurrency,
  }) {
    final amount = double.tryParse(amountText);
    if (amount == null || fromCurrency == null) {
      return const <String, double>{};
    }

    final rateFrom = state.currencyRates[fromCurrency];
    if (rateFrom == null || rateFrom == 0) {
      return const <String, double>{};
    }

    final amountInBase = amount / rateFrom;
    final results = <String, double>{};

    for (final entry in state.currencyRates.entries) {
      if (entry.key == fromCurrency) {
        continue;
      }
      results[entry.key] = amountInBase * entry.value;
    }

    return results;
  }
}
