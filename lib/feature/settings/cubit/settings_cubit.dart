import 'dart:async';

import 'package:currency_converter/core/utils/logger/logger_utils.dart';
import 'package:currency_converter/feature/convert/domain/usecases/get_currencies_usecase.dart';
import 'package:currency_converter/feature/settings/cubit/settings_state.dart';
import 'package:currency_converter/feature/web_accessibility/extension_settings_bridge.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit({
    required GetCurrenciesUseCase getCurrenciesUseCase,
    required ExtensionSettingsBridge extensionSettingsBridge,
  })  : _getCurrenciesUseCase = getCurrenciesUseCase,
        _extensionSettingsBridge = extensionSettingsBridge,
        super(SettingsState.initial());

  static const int _convertShowcaseStorageVersion = 2;

  final GetCurrenciesUseCase _getCurrenciesUseCase;
  final ExtensionSettingsBridge _extensionSettingsBridge;

  Future<void> initialize() async {
    unawaited(_syncExtensionSettings(state));
    emit(state.copyWith(status: SettingsStatus.loading));
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
      ),
    );
    unawaited(_syncExtensionSettings(state));
  }

  void updateDisplayCurrencies(List<String> currencies) {
    final ordered = _sortSelection(currencies, state.currencies);
    emit(
      state.copyWith(
        displayCurrencies: ordered,
        displaySelectionInitialized: true,
      ),
    );
  }

  void updateShowCurrencyFlags({required bool value}) {
    if (value == state.showCurrencyFlags) {
      return;
    }
    emit(
      state.copyWith(
        showCurrencyFlags: value,
      ),
    );
  }

  void updateUseCurrencySymbols({required bool value}) {
    if (value == state.useCurrencySymbols) {
      return;
    }
    emit(
      state.copyWith(
        useCurrencySymbols: value,
      ),
    );
  }

  void updateWebPriceAccessibility({required bool value}) {
    if (value == state.webPriceAccessibilityEnabled) {
      return;
    }
    emit(
      state.copyWith(
        webPriceAccessibilityEnabled: value,
      ),
    );
    unawaited(_syncExtensionSettings(state));
  }

  void markConvertShowcaseSeen() {
    if (state.convertShowcaseSeen) {
      return;
    }
    emit(
      state.copyWith(
        convertShowcaseSeen: true,
      ),
    );
  }

  void markChartsShowcaseSeen() {
    if (state.chartsShowcaseSeen) {
      return;
    }
    emit(
      state.copyWith(
        chartsShowcaseSeen: true,
      ),
    );
  }

  void markSettingsShowcaseSeen() {
    if (state.settingsShowcaseSeen) {
      return;
    }
    emit(
      state.copyWith(
        settingsShowcaseSeen: true,
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
        ),
      );
      unawaited(_syncExtensionSettings(state));
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

  Future<void> _syncExtensionSettings(SettingsState nextState) async {
    try {
      await _extensionSettingsBridge.syncSettings(
        ExtensionSettingsPayload(
          baseCurrency: nextState.baseCurrency,
          webPriceAccessibilityEnabled: nextState.webPriceAccessibilityEnabled,
        ),
      );
    } catch (error) {
      LoggerUtils.instance.logWarning(
        'Unable to sync extension settings: $error',
      );
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
    final rawShowCurrencyFlags = json['showCurrencyFlags'];
    final showCurrencyFlags =
        rawShowCurrencyFlags is! bool || rawShowCurrencyFlags;
    final rawUseCurrencySymbols = json['useCurrencySymbols'];
    final useCurrencySymbols =
        rawUseCurrencySymbols is! bool || rawUseCurrencySymbols;
    final rawWebPriceAccessibilityEnabled =
        json['webPriceAccessibilityEnabled'];
    final webPriceAccessibilityEnabled =
        rawWebPriceAccessibilityEnabled is! bool ||
            rawWebPriceAccessibilityEnabled;
    final rawConvertShowcaseSeen = json['convertShowcaseSeen'];
    final rawConvertShowcaseVersion = json['convertShowcaseSeenVersion'];
    final convertShowcaseSeen = rawConvertShowcaseSeen is bool &&
        rawConvertShowcaseSeen &&
        rawConvertShowcaseVersion == _convertShowcaseStorageVersion;
    final rawChartsShowcaseSeen = json['chartsShowcaseSeen'];
    final chartsShowcaseSeen =
        rawChartsShowcaseSeen is bool && rawChartsShowcaseSeen;
    final rawSettingsShowcaseSeen = json['settingsShowcaseSeen'];
    final settingsShowcaseSeen =
        rawSettingsShowcaseSeen is bool && rawSettingsShowcaseSeen;

    return SettingsState.initial().copyWith(
      currencies: currencies,
      baseCurrency: baseCurrency,
      baseSelectionInitialized: baseSelectionInitialized,
      displayCurrencies: displayCurrencies,
      displaySelectionInitialized: hasDisplaySelection,
      showCurrencyFlags: showCurrencyFlags,
      useCurrencySymbols: useCurrencySymbols,
      webPriceAccessibilityEnabled: webPriceAccessibilityEnabled,
      convertShowcaseSeen: convertShowcaseSeen,
      chartsShowcaseSeen: chartsShowcaseSeen,
      settingsShowcaseSeen: settingsShowcaseSeen,
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
      'showCurrencyFlags': state.showCurrencyFlags,
      'useCurrencySymbols': state.useCurrencySymbols,
      'webPriceAccessibilityEnabled': state.webPriceAccessibilityEnabled,
      'convertShowcaseSeen': state.convertShowcaseSeen,
      'convertShowcaseSeenVersion': _convertShowcaseStorageVersion,
      'chartsShowcaseSeen': state.chartsShowcaseSeen,
      'settingsShowcaseSeen': state.settingsShowcaseSeen,
    };
  }
}
