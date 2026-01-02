import 'package:currency_converter/feature/convert/domain/usecases/get_currencies_usecase.dart';
import 'package:currency_converter/feature/settings/cubit/settings_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit({
    required GetCurrenciesUseCase getCurrenciesUseCase,
  })  : _getCurrenciesUseCase = getCurrenciesUseCase,
        super(SettingsState.initial());

  final GetCurrenciesUseCase _getCurrenciesUseCase;

  Future<void> initialize() async {
    emit(state.copyWith(status: SettingsStatus.loading, errorMessage: null));
    await _loadCurrencies();
  }

  void updateBaseCurrency(String? currency) {
    if (currency == null || currency.isEmpty) {
      return;
    }
    if (currency == state.baseCurrency && state.baseSelectionInitialized) {
      return;
    }
    emit(
      state.copyWith(
        baseCurrency: currency,
        baseSelectionInitialized: true,
        errorMessage: null,
      ),
    );
  }

  void updateDisplayCurrencies(List<String> currencies) {
    final ordered = _sortSelection(currencies, state.currencies);
    emit(
      state.copyWith(
        displayCurrencies: ordered,
        displaySelectionInitialized: true,
        errorMessage: null,
      ),
    );
  }

  Future<void> _loadCurrencies() async {
    try {
      final currencies = await _fetchCurrencies();
      if (currencies.isEmpty) {
        emit(
          state.copyWith(
            status: SettingsStatus.failure,
            errorMessage: 'No currencies available.',
          ),
        );
        return;
      }

      final baseCurrency = currencies.contains(state.baseCurrency)
          ? state.baseCurrency
          : currencies.first;
      final displayCurrencies = state.displaySelectionInitialized
          ? _sortSelection(state.displayCurrencies, currencies)
          : state.displayCurrencies;

      emit(
        state.copyWith(
          status: SettingsStatus.success,
          currencies: currencies,
          baseCurrency: baseCurrency,
          displayCurrencies: displayCurrencies,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<List<String>> _fetchCurrencies() async {
    try {
      final result = await _getCurrenciesUseCase();
      final codes = result.keys.toList()..sort();
      return codes;
    } catch (_) {
      return state.currencies;
    }
  }

  List<String> _sortSelection(
    List<String> selection,
    List<String> currencies,
  ) {
    if (selection.isEmpty || currencies.isEmpty) {
      return selection;
    }
    final selectionSet = selection.toSet();
    return currencies.where(selectionSet.contains).toList();
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    final rawCurrencies = json['currencies'];
    final currencies = rawCurrencies is List
        ? rawCurrencies.whereType<String>().toList()
        : <String>[];
    final rawBase = json['baseCurrency'];
    final baseCurrency = rawBase is String ? rawBase : 'USD';
    final rawBaseInitialized = json['baseSelectionInitialized'];
    final baseSelectionInitialized = rawBaseInitialized is bool
        ? rawBaseInitialized
        : json.containsKey('baseSelectionInitialized');
    final rawDisplay = json['displayCurrencies'];
    final displayCurrencies = rawDisplay is List
        ? rawDisplay.whereType<String>().toList()
        : <String>[];
    final rawDisplayInitialized = json['displaySelectionInitialized'];
    final hasDisplaySelection = rawDisplayInitialized is bool
        ? rawDisplayInitialized
        : json.containsKey('displayCurrencies');

    return SettingsState.initial().copyWith(
      currencies: currencies,
      baseCurrency: baseCurrency,
      baseSelectionInitialized: baseSelectionInitialized,
      displayCurrencies: displayCurrencies,
      displaySelectionInitialized: hasDisplaySelection,
    );
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return <String, dynamic>{
      'currencies': state.currencies,
      'baseCurrency': state.baseCurrency,
      'baseSelectionInitialized': state.baseSelectionInitialized,
      'displayCurrencies': state.displayCurrencies,
      'displaySelectionInitialized': state.displaySelectionInitialized,
    };
  }
}
