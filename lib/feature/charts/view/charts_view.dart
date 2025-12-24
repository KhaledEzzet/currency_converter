import 'package:currency_converter/feature/convert/cubit/convert_state.dart';
import 'package:currency_converter/feature/convert/view/widgets/currency_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class _ChartPoint {
  const _ChartPoint(this.index, this.value);

  final int index;
  final double value;
}

class ChartsView extends StatefulWidget {
  const ChartsView({super.key});

  @override
  State<ChartsView> createState() => _ChartsViewState();
}

class _ChartsViewState extends State<ChartsView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late final ConvertState _baseState;
  late String _fromCurrency;
  late String _toCurrency;
  String _selectedRange = '1W';

  @override
  void initState() {
    super.initState();
    _baseState = ConvertState.initial();
    _fromCurrency = _baseState.fromCurrency ?? _baseState.currencies.first;
    _toCurrency = _baseState.currencies.firstWhere(
      (currency) => currency != _fromCurrency,
      orElse: () => _fromCurrency,
    );
  }

  void _swapCurrencies() {
    final formState = _formKey.currentState;
    final newFrom = _toCurrency;
    final newTo = _fromCurrency;

    setState(() {
      _fromCurrency = newFrom;
      _toCurrency = newTo;
    });

    formState?.fields['chart_from_currency']?.didChange(_fromCurrency);
    formState?.fields['chart_to_currency']?.didChange(_toCurrency);
  }

  double _rateForPair(String fromCurrency, String toCurrency) {
    final rateFrom = _baseState.currencyRates[fromCurrency] ?? 1;
    final rateTo = _baseState.currencyRates[toCurrency] ?? 1;
    if (rateFrom == 0) {
      return 0;
    }
    return rateTo / rateFrom;
  }

  List<double> _rangeOffsets(String range) {
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

  List<_ChartPoint> _buildChartPoints() {
    final base = _rateForPair(_fromCurrency, _toCurrency);
    final offsets = _rangeOffsets(_selectedRange);
    return List<_ChartPoint>.generate(
      offsets.length,
      (index) => _ChartPoint(index, base * (1 + offsets[index])),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rate = _rateForPair(_fromCurrency, _toCurrency);
    final rateText = rate == 0 ? '--' : rate.toStringAsFixed(4);
    final chartPoints = _buildChartPoints();
    final chartValues = chartPoints.map((point) => point.value).toList();
    final minValue = chartValues.reduce((a, b) => a < b ? a : b);
    final maxValue = chartValues.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Charts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FormBuilder(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: CurrencyDropdownField(
                      name: 'chart_from_currency',
                      state: _baseState,
                      initialValue: _fromCurrency,
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _fromCurrency = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: _swapCurrencies,
                    icon: const Icon(Icons.swap_horiz_rounded),
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CurrencyDropdownField(
                      name: 'chart_to_currency',
                      state: _baseState,
                      initialValue: _toCurrency,
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _toCurrency = value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '1 $_fromCurrency = $rateText $_toCurrency',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '-0.0047 (-0.55%) Past week',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children: [
                  for (final range in <String>['1W', '1M', '3M', '1Y', '5Y', '10Y'])
                    ChoiceChip(
                      label: Text(range),
                      selected: _selectedRange == range,
                      onSelected: (_) {
                        setState(() => _selectedRange = range);
                      },
                      selectedColor: const Color(0xFF3B5B87),
                      labelStyle: TextStyle(
                        color: _selectedRange == range
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: const BorderSide(
                        color: Color(0xFF3B5B87),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                margin: EdgeInsets.zero,
                primaryXAxis: const NumericAxis(
                  isVisible: false,
                ),
                primaryYAxis: NumericAxis(
                  minimum: minValue,
                  maximum: maxValue,
                  interval: range == 0 ? 1 : range,
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  majorGridLines: const MajorGridLines(width: 0),
                  labelStyle: const TextStyle(fontSize: 11),
                ),
                series: <SplineAreaSeries<_ChartPoint, int>>[
                  SplineAreaSeries<_ChartPoint, int>(
                    dataSource: chartPoints,
                    xValueMapper: (point, _) => point.index,
                    yValueMapper: (point, _) => point.value,
                    borderColor: const Color(0xFF3B5B87),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x553B5B87),
                        Color(0x003B5B87),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
