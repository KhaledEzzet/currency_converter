import 'package:currency_converter/app/l10n/arb/app_localizations.dart';
import 'package:currency_converter/app/l10n/l10n.dart';
import 'package:currency_converter/feature/charts/cubit/charts_cubit.dart';
import 'package:currency_converter/feature/charts/cubit/charts_state.dart';
import 'package:currency_converter/feature/charts/view/widgets/charts_currency_row.dart';
import 'package:currency_converter/feature/charts/view/widgets/performance_summary.dart';
import 'package:currency_converter/feature/charts/view/widgets/range_selector.dart';
import 'package:currency_converter/feature/charts/view/widgets/rate_chart.dart';
import 'package:currency_converter/feature/charts/view/widgets/rate_header.dart';
import 'package:currency_converter/feature/settings/cubit/settings_cubit.dart';
import 'package:currency_converter/feature/settings/cubit/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChartsView extends StatelessWidget {
  const ChartsView({super.key});

  String _rangeLabel(AppLocalizations l10n, String range) {
    switch (range) {
      case '1M':
        return l10n.rangePastMonth;
      case '3M':
        return l10n.rangePastThreeMonths;
      case '1Y':
        return l10n.rangePastYear;
      case '5Y':
        return l10n.rangePastFiveYears;
      case '10Y':
        return l10n.rangePastTenYears;
      case '1W':
      default:
        return l10n.rangePastWeek;
    }
  }

  String _rangeShortLabel(AppLocalizations l10n, String range) {
    switch (range) {
      case '1M':
        return l10n.rangeShortMonth;
      case '3M':
        return l10n.rangeShortThreeMonths;
      case '1Y':
        return l10n.rangeShortYear;
      case '5Y':
        return l10n.rangeShortFiveYears;
      case '10Y':
        return l10n.rangeShortTenYears;
      case '1W':
      default:
        return l10n.rangeShortWeek;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChartsCubit>();
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.titleCharts,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: BlocListener<SettingsCubit, SettingsState>(
        listenWhen: (previous, current) =>
            previous.baseCurrency != current.baseCurrency ||
            previous.baseSelectionInitialized !=
                current.baseSelectionInitialized,
        listener: (context, settingsState) {
          if (!settingsState.baseSelectionInitialized) {
            return;
          }
          if (settingsState.baseCurrency.isNotEmpty &&
              settingsState.baseCurrency !=
                  context.read<ChartsCubit>().state.fromCurrency) {
            context
                .read<ChartsCubit>()
                .updateFromCurrency(settingsState.baseCurrency);
          }
        },
        child: BlocConsumer<ChartsCubit, ChartsState>(
          listener: (context, state) => cubit.syncFormFields(),
          builder: (context, state) {
            if (state.status == ChartsStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage ?? l10n.errorGeneric,
                ),
              );
            }

            final isLoading = state.status == ChartsStatus.loading ||
                (state.status == ChartsStatus.initial &&
                    state.currencies.isEmpty);
            final settingsState = context.watch<SettingsCubit>().state;
            final showCurrencyFlags = settingsState.showCurrencyFlags;
            final rateText =
                state.rate == 0 ? '--' : state.rate.toStringAsFixed(4);
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
              ..write(_rangeLabel(l10n, state.selectedRange));
            final mockChartPoints = List<ChartsPoint>.generate(
              20,
              (index) => ChartsPoint(
                index,
                1.2 + (index % 5) * 0.15,
              ),
            );
            final (mockMinValue, mockMaxValue, mockInterval) =
                ChartsState.calculateStats(mockChartPoints);
            final chartPoints = isLoading ? mockChartPoints : state.chartPoints;
            final minValue = isLoading ? mockMinValue : state.minValue;
            final maxValue = isLoading ? mockMaxValue : state.maxValue;
            final yInterval = isLoading ? mockInterval : state.yInterval;
            final fromCurrency =
                isLoading ? BoneMock.chars(3) : state.fromCurrency;
            final toCurrency = isLoading ? BoneMock.chars(3) : state.toCurrency;
            final fromFlagCode =
                isLoading ? null : state.currencyFlags[state.fromCurrency];
            final toFlagCode =
                isLoading ? null : state.currencyFlags[state.toCurrency];
            final displayRateText = isLoading ? BoneMock.chars(6) : rateText;
            final performanceText = isLoading
                ? '${BoneMock.chars(6)} (${BoneMock.chars(5)}%) '
                    '${_rangeLabel(l10n, state.selectedRange)}'
                : changeText.toString();

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
                    onFromChanged: (currency) {
                      if (currency == null) {
                        return;
                      }
                      context
                          .read<SettingsCubit>()
                          .updateBaseCurrency(currency);
                    },
                    onToChanged: cubit.updateToCurrency,
                    onSwap: () async {
                      final settingsCubit = context.read<SettingsCubit>();
                      await cubit.swapCurrencies();
                      final baseCurrency = cubit.state.fromCurrency;
                      if (baseCurrency.isNotEmpty) {
                        settingsCubit.updateBaseCurrency(baseCurrency);
                      }
                    },
                    showCurrencyFlags: showCurrencyFlags,
                  ),
                  const SizedBox(height: 20),
                  Skeletonizer(
                    enabled: isLoading,
                    child: RateHeader(
                      fromCurrency: fromCurrency,
                      toCurrency: toCurrency,
                      rateText: displayRateText,
                      dotColor: changeColor,
                      fromFlagCode: fromFlagCode,
                      toFlagCode: toFlagCode,
                      showFlags: showCurrencyFlags,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Skeletonizer(
                    enabled: isLoading,
                    child: PerformanceSummary(
                      text: performanceText,
                      color: changeColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RangeSelector(
                    ranges: const ['1W', '1M', '3M', '1Y', '5Y', '10Y'],
                    selectedRange: state.selectedRange,
                    onSelected: cubit.updateRange,
                    labelBuilder: (range) => _rangeShortLabel(l10n, range),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Skeletonizer(
                      enabled: isLoading,
                      child: RateChart(
                        points: chartPoints,
                        minValue: minValue,
                        maxValue: maxValue,
                        yInterval: yInterval,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
