enum ConvertStatus { initial, updated }

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
  });

  final ConvertStatus status;
  final List<String> currencies;
  final Map<String, String> currencySymbols;
  final Map<String, String> currencyFlags;
  final Map<String, double> currencyRates;
  final String? fromCurrency;
  final String amountText;
  final Map<String, double> convertedAmounts;

  factory ConvertState.initial() {
    return const ConvertState(
      status: ConvertStatus.initial,
      currencies: <String>['USD', 'EUR', 'GBP', 'JPY'],
      currencySymbols: <String, String>{
        'USD': r'$',
        'EUR': '\u20AC',
        'GBP': '\u00A3',
        'JPY': '\u00A5',
      },
      currencyFlags: <String, String>{
        'USD': 'us',
        'EUR': 'eu',
        'GBP': 'gb',
        'JPY': 'jp',
      },
      currencyRates: <String, double>{
        'USD': 1,
        'EUR': 0.92,
        'GBP': 0.79,
        'JPY': 156,
      },
      fromCurrency: 'USD',
      amountText: '',
      convertedAmounts: <String, double>{},
    );
  }

  ConvertState copyWith({
    ConvertStatus? status,
    List<String>? currencies,
    Map<String, String>? currencySymbols,
    Map<String, String>? currencyFlags,
    Map<String, double>? currencyRates,
    String? fromCurrency,
    String? amountText,
    Map<String, double>? convertedAmounts,
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
    );
  }
}
