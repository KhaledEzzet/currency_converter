import 'package:currency_converter/feature/convert/domain/usecases/get_currencies_usecase.dart';
import 'package:currency_converter/feature/convert/domain/usecases/get_latest_rates_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:currency_converter/feature/convert/cubit/convert_state.dart';

class ConvertCubit extends Cubit<ConvertState> {
  ConvertCubit({
    required GetLatestRatesUseCase getLatestRatesUseCase,
    required GetCurrenciesUseCase getCurrenciesUseCase,
  })  : _getLatestRatesUseCase = getLatestRatesUseCase,
        _getCurrenciesUseCase = getCurrenciesUseCase,
        super(ConvertState.initial());

  final GetLatestRatesUseCase _getLatestRatesUseCase;
  final GetCurrenciesUseCase _getCurrenciesUseCase;

  Future<void> initialize() async {
    emit(state.copyWith(status: ConvertStatus.loading, errorMessage: null));
    await _loadRates(fromCurrency: state.fromCurrency, refreshCurrencies: true);
  }

  Future<void> updateFromCurrency(String? currency) async {
    if (currency == null) {
      return;
    }

    emit(
      state.copyWith(
        status: ConvertStatus.loading,
        fromCurrency: currency,
        errorMessage: null,
      ),
    );

    await _loadRates(fromCurrency: currency);
  }

  void updateAmount(String amountText) {
    final convertedAmounts = _calculateConversions(
      amountText: amountText,
      rates: state.currencyRates,
    );
    emit(
      state.copyWith(
        status: ConvertStatus.success,
        amountText: amountText,
        convertedAmounts: convertedAmounts,
        errorMessage: null,
      ),
    );
  }

  Future<void> _loadRates({
    required String fromCurrency,
    bool refreshCurrencies = false,
  }) async {
    try {
      final currencies = refreshCurrencies
          ? await _refreshCurrencies()
          : state.currencies;
      final resolvedFrom = currencies.contains(fromCurrency)
          ? fromCurrency
          : (currencies.isNotEmpty ? currencies.first : fromCurrency);
      final targets =
          currencies.where((currency) => currency != resolvedFrom).toList();
      final latestRates = await _getLatestRatesUseCase(
        from: resolvedFrom,
        to: targets,
      );
      final convertedAmounts = _calculateConversions(
        amountText: state.amountText,
        rates: latestRates.rates,
      );
      final currencySymbols = _buildCurrencySymbols(currencies);
      final currencyFlags = _buildCurrencyFlags(currencies);

      emit(
        state.copyWith(
          status: ConvertStatus.success,
          currencies: currencies,
          fromCurrency: resolvedFrom,
          currencyRates: latestRates.rates,
          convertedAmounts: convertedAmounts,
          currencySymbols: currencySymbols,
          currencyFlags: currencyFlags,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ConvertStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<List<String>> _refreshCurrencies() async {
    try {
      final apiCurrencies = await _getCurrenciesUseCase();
      final codes = apiCurrencies.keys.toList()..sort();
      return codes;
    } catch (_) {
      return state.currencies;
    }
  }

  Map<String, double> _calculateConversions({
    required String amountText,
    required Map<String, double> rates,
  }) {
    final amount = double.tryParse(amountText);
    if (amount == null) {
      return const <String, double>{};
    }

    if (rates.isEmpty) {
      return const <String, double>{};
    }

    final results = <String, double>{};

    for (final entry in rates.entries) {
      results[entry.key] = amount * entry.value;
    }

    return results;
  }

  Map<String, String> _buildCurrencySymbols(List<String> currencies) {
    final symbols = <String, String>{};
    for (final currency in currencies) {
      final symbol = NumberFormat.simpleCurrency(name: currency).currencySymbol;
      if (symbol.isNotEmpty && symbol != currency) {
        symbols[currency] = symbol;
      }
    }
    return symbols;
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
