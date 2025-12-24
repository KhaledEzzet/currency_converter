enum ChartsStatus { initial, updated }

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
    required this.currencyRates,
    required this.fromCurrency,
    required this.toCurrency,
    required this.selectedRange,
    required this.rate,
    required this.chartPoints,
    required this.minValue,
    required this.maxValue,
    required this.yInterval,
  });

  final ChartsStatus status;
  final List<String> currencies;
  final Map<String, String> currencyFlags;
  final Map<String, double> currencyRates;
  final String fromCurrency;
  final String toCurrency;
  final String selectedRange;
  final double rate;
  final List<ChartsPoint> chartPoints;
  final double minValue;
  final double maxValue;
  final double yInterval;

  factory ChartsState.initial() {
    const currencies = <String>['USD', 'EUR', 'GBP', 'JPY'];
    const currencyFlags = <String, String>{
      'USD': 'us',
      'EUR': 'eu',
      'GBP': 'gb',
      'JPY': 'jp',
    };
    const currencyRates = <String, double>{
      'USD': 1,
      'EUR': 0.92,
      'GBP': 0.79,
      'JPY': 156,
    };
    const fromCurrency = 'USD';
    final toCurrency = currencies.firstWhere(
      (currency) => currency != fromCurrency,
      orElse: () => fromCurrency,
    );
    const selectedRange = '1W';
    final rate = currencyRates[toCurrency]! / currencyRates[fromCurrency]!;
    final chartPoints = _buildInitialChartPoints(rate, selectedRange);
    final (minValue, maxValue, yInterval) = calculateStats(chartPoints);

    return ChartsState(
      status: ChartsStatus.initial,
      currencies: currencies,
      currencyFlags: currencyFlags,
      currencyRates: currencyRates,
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      selectedRange: selectedRange,
      rate: rate,
      chartPoints: chartPoints,
      minValue: minValue,
      maxValue: maxValue,
      yInterval: yInterval,
    );
  }

  ChartsState copyWith({
    ChartsStatus? status,
    List<String>? currencies,
    Map<String, String>? currencyFlags,
    Map<String, double>? currencyRates,
    String? fromCurrency,
    String? toCurrency,
    String? selectedRange,
    double? rate,
    List<ChartsPoint>? chartPoints,
    double? minValue,
    double? maxValue,
    double? yInterval,
  }) {
    return ChartsState(
      status: status ?? this.status,
      currencies: currencies ?? this.currencies,
      currencyFlags: currencyFlags ?? this.currencyFlags,
      currencyRates: currencyRates ?? this.currencyRates,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      selectedRange: selectedRange ?? this.selectedRange,
      rate: rate ?? this.rate,
      chartPoints: chartPoints ?? this.chartPoints,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      yInterval: yInterval ?? this.yInterval,
    );
  }

  static List<ChartsPoint> _buildInitialChartPoints(
    double baseRate,
    String range,
  ) {
    final offsets = rangeOffsets(range);
    return List<ChartsPoint>.generate(
      offsets.length,
      (index) => ChartsPoint(index, baseRate * (1 + offsets[index])),
    );
  }

  static List<double> rangeOffsets(String range) {
    switch (range) {
      case '1M':
        return const [
          -0.012,
          -0.009,
          -0.006,
          -0.002,
          0.004,
          0.006,
          0.001,
          -0.004,
          0.002,
          0.009,
          0.012,
          0.007,
          0.002,
          -0.003,
          -0.008,
          -0.004,
          0.001,
          0.008,
          0.011,
          0.006,
          -0.001,
          -0.006,
          -0.01,
          -0.005,
          0.0,
          0.004,
          0.009,
          0.013,
          0.008,
          0.003,
        ];
      case '3M':
        return const [
          -0.018,
          -0.012,
          -0.005,
          0.002,
          0.006,
          0.01,
          0.004,
          -0.004,
          -0.011,
          -0.007,
          0.001,
          0.009,
          0.015,
          0.009,
          0.003,
          -0.005,
          -0.012,
          -0.006,
          0.002,
          0.008,
          0.013,
          0.007,
          0.001,
          -0.009,
        ];
      case '1Y':
        return const [
          -0.022,
          -0.017,
          -0.01,
          -0.004,
          0.003,
          0.01,
          0.016,
          0.011,
          0.004,
          -0.003,
          -0.012,
          -0.018,
          -0.011,
          -0.004,
          0.002,
          0.009,
          0.014,
          0.008,
          0.001,
          -0.008,
          -0.015,
          -0.009,
          -0.002,
          0.006,
          0.013,
          0.018,
          0.012,
          0.005,
        ];
      case '5Y':
        return const [
          -0.028,
          -0.02,
          -0.012,
          -0.004,
          0.006,
          0.014,
          0.022,
          0.016,
          0.009,
          0.001,
          -0.008,
          -0.018,
          -0.026,
          -0.017,
          -0.008,
          0.0,
          0.011,
          0.02,
          0.026,
          0.018,
          0.008,
          -0.003,
          -0.014,
          -0.022,
          -0.015,
          -0.006,
          0.004,
          0.013,
          0.021,
          0.015,
        ];
      case '10Y':
        return const [
          -0.03,
          -0.022,
          -0.014,
          -0.006,
          0.004,
          0.012,
          0.02,
          0.028,
          0.021,
          0.013,
          0.004,
          -0.005,
          -0.016,
          -0.024,
          -0.018,
          -0.009,
          0.001,
          0.011,
          0.019,
          0.027,
          0.02,
          0.011,
          0.002,
          -0.009,
          -0.019,
          -0.026,
          -0.017,
          -0.008,
          0.003,
          0.014,
        ];
      case '1W':
      default:
        return const [
          -0.01,
          -0.006,
          -0.002,
          0.004,
          0.012,
          0.006,
          -0.001,
          -0.007,
          -0.003,
          0.003,
          0.01,
          0.005,
          -0.004,
          -0.008,
          -0.002,
        ];
    }
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
