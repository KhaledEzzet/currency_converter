enum SettingsStatus { initial, loading, success, failure }

class SettingsState {
  const SettingsState({
    required this.status,
    required this.currencies,
    required this.baseCurrency,
    required this.baseSelectionInitialized,
    required this.displayCurrencies,
    required this.displaySelectionInitialized,
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
      errorMessage: null,
    );
  }

  final SettingsStatus status;
  final List<String> currencies;
  final String baseCurrency;
  final bool baseSelectionInitialized;
  final List<String> displayCurrencies;
  final bool displaySelectionInitialized;
  final String? errorMessage;

  SettingsState copyWith({
    SettingsStatus? status,
    List<String>? currencies,
    String? baseCurrency,
    bool? baseSelectionInitialized,
    List<String>? displayCurrencies,
    bool? displaySelectionInitialized,
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
      errorMessage: errorMessage,
    );
  }
}
