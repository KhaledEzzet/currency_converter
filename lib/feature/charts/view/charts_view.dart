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

  String _rangeLabel(String range) {
    switch (range) {
      case '1M':
        return 'Past month';
      case '3M':
        return 'Past 3 months';
      case '1Y':
        return 'Past year';
      case '5Y':
        return 'Past 5 years';
      case '10Y':
        return 'Past 10 years';
      case '1W':
      default:
        return 'Past week';
    }
  }

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
          if (state.status == ChartsStatus.loading ||
              (state.status == ChartsStatus.initial &&
                  state.currencies.isEmpty)) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status == ChartsStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Something went wrong.',
              ),
            );
          }

          final rateText = state.rate == 0 ? '--' : state.rate.toStringAsFixed(4);
          final changeValue = state.changeValue;
          final changePercent = state.changePercent;
          final changeColor =
              changeValue < 0 ? Colors.redAccent : Colors.green;
          final changeText = StringBuffer()
            ..write(changeValue >= 0 ? '+' : '')
            ..write(changeValue.toStringAsFixed(4))
            ..write(' (')
            ..write(changePercent >= 0 ? '+' : '')
            ..write(changePercent.toStringAsFixed(2))
            ..write('%) ')
            ..write(_rangeLabel(state.selectedRange));

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
                  dotColor: changeColor,
                ),
                const SizedBox(height: 6),
                PerformanceSummary(
                  text: changeText.toString(),
                  color: changeColor,
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
