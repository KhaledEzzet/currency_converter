enum SettingsStatus { initial, loading, success, failure }

class SettingsState {
  const SettingsState({
    required this.status,
    required this.currencies,
    required this.baseCurrency,
    required this.baseSelectionInitialized,
    required this.displayCurrencies,
    required this.displaySelectionInitialized,
    required this.showCurrencyFlags,
    required this.useCurrencySymbols,
    required this.convertShowcaseSeen,
    required this.chartsShowcaseSeen,
    required this.settingsShowcaseSeen,
    required this.errorMessage,
  });

  factory SettingsState.initial() {
    return const SettingsState(
      status: SettingsStatus.initial,
      currencies: <String>[],
      baseCurrency: 'USD',
      baseSelectionInitialized: false,
      displayCurrencies: <String>[],
      displaySelectionInitialized: false,
      showCurrencyFlags: true,
      useCurrencySymbols: true,
      convertShowcaseSeen: false,
      chartsShowcaseSeen: false,
      settingsShowcaseSeen: false,
      errorMessage: null,
    );
  }

  final SettingsStatus status;
  final List<String> currencies;
  final String baseCurrency;
  final bool baseSelectionInitialized;
  final List<String> displayCurrencies;
  final bool displaySelectionInitialized;
  final bool showCurrencyFlags;
  final bool useCurrencySymbols;
  final bool convertShowcaseSeen;
  final bool chartsShowcaseSeen;
  final bool settingsShowcaseSeen;
  final String? errorMessage;

  SettingsState copyWith({
    SettingsStatus? status,
    List<String>? currencies,
    String? baseCurrency,
    bool? baseSelectionInitialized,
    List<String>? displayCurrencies,
    bool? displaySelectionInitialized,
    bool? showCurrencyFlags,
    bool? useCurrencySymbols,
    bool? convertShowcaseSeen,
    bool? chartsShowcaseSeen,
    bool? settingsShowcaseSeen,
    String? errorMessage,
  }) {
    return SettingsState(
      status: status ?? this.status,
      currencies: currencies ?? this.currencies,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      baseSelectionInitialized:
          baseSelectionInitialized ?? this.baseSelectionInitialized,
      displayCurrencies: displayCurrencies ?? this.displayCurrencies,
      displaySelectionInitialized:
          displaySelectionInitialized ?? this.displaySelectionInitialized,
      showCurrencyFlags: showCurrencyFlags ?? this.showCurrencyFlags,
      useCurrencySymbols: useCurrencySymbols ?? this.useCurrencySymbols,
      convertShowcaseSeen: convertShowcaseSeen ?? this.convertShowcaseSeen,
      chartsShowcaseSeen: chartsShowcaseSeen ?? this.chartsShowcaseSeen,
      settingsShowcaseSeen: settingsShowcaseSeen ?? this.settingsShowcaseSeen,
      errorMessage: errorMessage,
    );
  }
}
