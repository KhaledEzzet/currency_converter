class LatestRates {
  const LatestRates({
    required this.amount,
    required this.base,
    required this.date,
    required this.rates,
  });

  final double amount;
  final String base;
  final String date;
  final Map<String, double> rates;
}
