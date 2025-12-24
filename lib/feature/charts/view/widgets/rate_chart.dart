import 'package:currency_converter/feature/charts/cubit/charts_state.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RateChart extends StatelessWidget {
  const RateChart({
    super.key,
    required this.points,
    required this.minValue,
    required this.maxValue,
    required this.yInterval,
  });

  final List<ChartsPoint> points;
  final double minValue;
  final double maxValue;
  final double yInterval;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      margin: EdgeInsets.zero,
      primaryXAxis: const NumericAxis(
        isVisible: false,
      ),
      primaryYAxis: NumericAxis(
        minimum: minValue,
        maximum: maxValue,
        interval: yInterval,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: const MajorGridLines(width: 0),
        labelStyle: const TextStyle(fontSize: 11),
      ),
      series: <SplineAreaSeries<ChartsPoint, int>>[
        SplineAreaSeries<ChartsPoint, int>(
          dataSource: points,
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
    );
  }
}
