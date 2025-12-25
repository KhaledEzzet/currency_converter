class TimeseriesRates {
  const TimeseriesRates({
    required this.base,
    required this.startDate,
    required this.endDate,
    required this.rates,
  });

  final String base;
  final DateTime startDate;
  final DateTime endDate;
  final Map<DateTime, double> rates;
}
