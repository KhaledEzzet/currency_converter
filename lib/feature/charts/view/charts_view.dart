import 'package:currency_converter/feature/charts/cubit/charts_cubit.dart';
import 'package:currency_converter/feature/charts/cubit/charts_state.dart';
import 'package:currency_converter/feature/convert/view/widgets/currency_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartsView extends StatefulWidget {
  const ChartsView({super.key});

  @override
  State<ChartsView> createState() => _ChartsViewState();
}

class _ChartsViewState extends State<ChartsView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  void _syncFormFields(ChartsState state) {
    final formState = _formKey.currentState;
    if (formState == null) {
      return;
    }

    final fromField = formState.fields['chart_from_currency'];
    if (fromField?.value != state.fromCurrency) {
      fromField?.didChange(state.fromCurrency);
    }

    final toField = formState.fields['chart_to_currency'];
    if (toField?.value != state.toCurrency) {
      toField?.didChange(state.toCurrency);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Charts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<ChartsCubit, ChartsState>(
        listener: (context, state) => _syncFormFields(state),
        builder: (context, state) {
          final rateText = state.rate == 0 ? '--' : state.rate.toStringAsFixed(4);
          final chartValues =
              state.chartPoints.map((point) => point.value).toList();
          final minValue = chartValues.isEmpty
              ? 0.0
              : chartValues.reduce((a, b) => a < b ? a : b);
          final maxValue = chartValues.isEmpty
              ? 0.0
              : chartValues.reduce((a, b) => a > b ? a : b);
          final range = maxValue - minValue;

          return Padding(
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
                          currencies: state.currencies,
                          currencyFlags: state.currencyFlags,
                          initialValue: state.fromCurrency,
                          onChanged: context.read<ChartsCubit>().updateFromCurrency,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: context.read<ChartsCubit>().swapCurrencies,
                        icon: const Icon(Icons.swap_horiz_rounded),
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CurrencyDropdownField(
                          name: 'chart_to_currency',
                          currencies: state.currencies,
                          currencyFlags: state.currencyFlags,
                          initialValue: state.toCurrency,
                          onChanged: context.read<ChartsCubit>().updateToCurrency,
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
                        '1 ${state.fromCurrency} = $rateText ${state.toCurrency}',
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
                      for (final range in <String>[
                        '1W',
                        '1M',
                        '3M',
                        '1Y',
                        '5Y',
                        '10Y',
                      ])
                        ChoiceChip(
                          label: Text(range),
                          selected: state.selectedRange == range,
                          onSelected: (_) {
                            context.read<ChartsCubit>().updateRange(range);
                          },
                          selectedColor: const Color(0xFF3B5B87),
                          labelStyle: TextStyle(
                            color: state.selectedRange == range
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
                    series: <SplineAreaSeries<ChartsPoint, int>>[
                      SplineAreaSeries<ChartsPoint, int>(
                        dataSource: state.chartPoints,
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
          );
        },
      ),
    );
  }
}
