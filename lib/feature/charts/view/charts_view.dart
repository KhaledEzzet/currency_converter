import 'package:currency_converter/feature/charts/cubit/charts_cubit.dart';
import 'package:currency_converter/feature/charts/cubit/charts_state.dart';
import 'package:currency_converter/feature/charts/view/widgets/charts_currency_row.dart';
import 'package:currency_converter/feature/charts/view/widgets/performance_summary.dart';
import 'package:currency_converter/feature/charts/view/widgets/range_selector.dart';
import 'package:currency_converter/feature/charts/view/widgets/rate_chart.dart';
import 'package:currency_converter/feature/charts/view/widgets/rate_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartsView extends StatelessWidget {
  const ChartsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChartsCubit>();

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
        listener: (context, state) => cubit.syncFormFields(),
        builder: (context, state) {
          final rateText = state.rate == 0 ? '--' : state.rate.toStringAsFixed(4);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ChartsCurrencyRow(
                  formKey: cubit.formKey,
                  currencies: state.currencies,
                  currencyFlags: state.currencyFlags,
                  fromCurrency: state.fromCurrency,
                  toCurrency: state.toCurrency,
                  onFromChanged: cubit.updateFromCurrency,
                  onToChanged: cubit.updateToCurrency,
                  onSwap: cubit.swapCurrencies,
                ),
                const SizedBox(height: 20),
                RateHeader(
                  fromCurrency: state.fromCurrency,
                  toCurrency: state.toCurrency,
                  rateText: rateText,
                ),
                const SizedBox(height: 6),
                const PerformanceSummary(
                  text: '-0.0047 (-0.55%) Past week',
                ),
                const SizedBox(height: 16),
                RangeSelector(
                  ranges: const ['1W', '1M', '3M', '1Y', '5Y', '10Y'],
                  selectedRange: state.selectedRange,
                  onSelected: cubit.updateRange,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: RateChart(
                    points: state.chartPoints,
                    minValue: state.minValue,
                    maxValue: state.maxValue,
                    yInterval: state.yInterval,
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
