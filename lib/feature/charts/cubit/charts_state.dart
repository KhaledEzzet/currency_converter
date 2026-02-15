enum ChartsStatus { initial, loading, success, failure }

class ChartsPoint {
  const ChartsPoint(this.index, this.value);

  final int index;
  final double value;
}

class ChartsState {
  const ChartsState({
    required this.status,
    required this.currencies,
    required this.currencyFlags,
    required this.fromCurrency,
    required this.toCurrency,
    required this.selectedRange,
    required this.rate,
    required this.changeValue,
    required this.changePercent,
    required this.chartPoints,
    required this.minValue,
    required this.maxValue,
    required this.yInterval,
    required this.errorMessage,
  });

  factory ChartsState.initial() {
    return const ChartsState(
      status: ChartsStatus.initial,
      currencies: <String>[],
      currencyFlags: <String, String>{},
      fromCurrency: '',
      toCurrency: '',
      selectedRange: '1W',
      rate: 0,
      changeValue: 0,
      changePercent: 0,
      chartPoints: <ChartsPoint>[],
      minValue: 0,
      maxValue: 0,
      yInterval: 1,
      errorMessage: null,
    );
  }

  final ChartsStatus status;
  final List<String> currencies;
  final Map<String, String> currencyFlags;
  final String fromCurrency;
  final String toCurrency;
  final String selectedRange;
  final double rate;
  final double changeValue;
  final double changePercent;
  final List<ChartsPoint> chartPoints;
  final double minValue;
  final double maxValue;
  final double yInterval;
  final String? errorMessage;

  ChartsState copyWith({
    ChartsStatus? status,
    List<String>? currencies,
    Map<String, String>? currencyFlags,
    String? fromCurrency,
    String? toCurrency,
    String? selectedRange,
    double? rate,
    double? changeValue,
    double? changePercent,
    List<ChartsPoint>? chartPoints,
    double? minValue,
    double? maxValue,
    double? yInterval,
    String? errorMessage,
  }) {
    return ChartsState(
      status: status ?? this.status,
      currencies: currencies ?? this.currencies,
      currencyFlags: currencyFlags ?? this.currencyFlags,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      selectedRange: selectedRange ?? this.selectedRange,
      rate: rate ?? this.rate,
      changeValue: changeValue ?? this.changeValue,
      changePercent: changePercent ?? this.changePercent,
      chartPoints: chartPoints ?? this.chartPoints,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      yInterval: yInterval ?? this.yInterval,
      errorMessage: errorMessage,
    );
  }

  static (double minValue, double maxValue, double yInterval) calculateStats(
    List<ChartsPoint> points,
  ) {
    if (points.isEmpty) {
      return (0, 0, 1);
    }

    final values = points.map((point) => point.value).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;
    final interval = range == 0 ? 1.0 : range;

    return (minValue, maxValue, interval);
  }
}
