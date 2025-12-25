enum ConvertStatus { initial, loading, success, failure }

class ConvertState {
  const ConvertState({
    required this.status,
    required this.currencies,
    required this.currencySymbols,
    required this.currencyFlags,
    required this.currencyRates,
    required this.fromCurrency,
    required this.amountText,
    required this.convertedAmounts,
    required this.errorMessage,
  });

  factory ConvertState.initial() {
    return const ConvertState(
      status: ConvertStatus.initial,
      currencies: <String>[],
      currencySymbols: <String, String>{},
      currencyFlags: <String, String>{},
      currencyRates: <String, double>{},
      fromCurrency: 'USD',
      amountText: '',
      convertedAmounts: <String, double>{},
      errorMessage: null,
    );
  }

  final ConvertStatus status;
  final List<String> currencies;
  final Map<String, String> currencySymbols;
  final Map<String, String> currencyFlags;
  final Map<String, double> currencyRates;
  final String fromCurrency;
  final String amountText;
  final Map<String, double> convertedAmounts;
  final String? errorMessage;

  ConvertState copyWith({
    ConvertStatus? status,
    List<String>? currencies,
    Map<String, String>? currencySymbols,
    Map<String, String>? currencyFlags,
    Map<String, double>? currencyRates,
    String? fromCurrency,
    String? amountText,
    Map<String, double>? convertedAmounts,
    String? errorMessage,
  }) {
    return ConvertState(
      status: status ?? this.status,
      currencies: currencies ?? this.currencies,
      currencySymbols: currencySymbols ?? this.currencySymbols,
      currencyFlags: currencyFlags ?? this.currencyFlags,
      currencyRates: currencyRates ?? this.currencyRates,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      amountText: amountText ?? this.amountText,
      convertedAmounts: convertedAmounts ?? this.convertedAmounts,
      errorMessage: errorMessage,
    );
  }
}
