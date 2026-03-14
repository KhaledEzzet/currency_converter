import 'package:currency_converter/app/l10n/arb/app_localizations.dart';
import 'package:currency_converter/app/l10n/l10n.dart';
import 'package:currency_converter/feature/charts/cubit/charts_cubit.dart';
import 'package:currency_converter/feature/charts/cubit/charts_state.dart';
import 'package:currency_converter/feature/charts/view/widgets/charts_currency_row.dart';
import 'package:currency_converter/feature/charts/view/widgets/performance_summary.dart';
import 'package:currency_converter/feature/charts/view/widgets/range_selector.dart';
import 'package:currency_converter/feature/charts/view/widgets/rate_chart.dart';
import 'package:currency_converter/feature/charts/view/widgets/rate_header.dart';
import 'package:currency_converter/feature/onboarding/cubit/onboarding_cubit.dart';
import 'package:currency_converter/feature/settings/cubit/settings_cubit.dart';
import 'package:currency_converter/feature/settings/cubit/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChartsView extends StatefulWidget {
  const ChartsView({super.key});

  @override
  State<ChartsView> createState() => _ChartsViewState();
}

class _ChartsViewState extends State<ChartsView> {
  static const _showcaseScope = 'charts_view_showcase';

  final GlobalKey _baseCurrencyShowcaseKey = GlobalKey();
  final GlobalKey _targetCurrencyShowcaseKey = GlobalKey();
  final GlobalKey _swapShowcaseKey = GlobalKey();
  final GlobalKey _timeFrameShowcaseKey = GlobalKey();

  late final ShowcaseView _showcaseView;
  bool _showcaseScheduled = false;

  @override
  void initState() {
    super.initState();
    _showcaseView = ShowcaseView.register(
      scope: _showcaseScope,
      enableAutoScroll: true,
      onFinish: _markChartsShowcaseSeen,
      onDismiss: (_) => _markChartsShowcaseSeen(),
      globalTooltipActionConfig: const TooltipActionConfig(),
      globalTooltipActions: const [
        TooltipActionButton(type: TooltipDefaultActionType.skip),
        TooltipActionButton(type: TooltipDefaultActionType.next),
      ],
    );
  }

  @override
  void dispose() {
    _showcaseView.unregister();
    super.dispose();
  }

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

  void _markChartsShowcaseSeen() {
    if (!mounted) {
      return;
    }
    context.read<SettingsCubit>().markChartsShowcaseSeen();
  }

  void _maybeStartShowcase({
    required ChartsState chartsState,
    required SettingsState settingsState,
    required bool hasCompletedOnboarding,
    required bool isViewVisible,
  }) {
    if (_showcaseScheduled ||
        !hasCompletedOnboarding ||
        !isViewVisible ||
        chartsState.status != ChartsStatus.success ||
        settingsState.status != SettingsStatus.success ||
        settingsState.chartsShowcaseSeen ||
        chartsState.currencies.isEmpty) {
      return;
    }

    _showcaseScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _showcaseView.startShowCase(
        [
          _baseCurrencyShowcaseKey,
          _targetCurrencyShowcaseKey,
          _swapShowcaseKey,
          _timeFrameShowcaseKey,
        ],
        delay: const Duration(milliseconds: 300),
      );
    });
  }

  Widget _buildShowcase(
    BuildContext context, {
    required GlobalKey key,
    required String title,
    required String description,
    required Widget child,
    TooltipPosition? tooltipPosition,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Showcase(
      key: key,
      title: title,
      description: description,
      tooltipPosition: tooltipPosition,
      tooltipBackgroundColor: colorScheme.surface,
      textColor: colorScheme.onSurface,
      titleTextStyle: theme.textTheme.titleMedium?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
      descTextStyle: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
        height: 1.4,
      ),
      overlayOpacity: 0.72,
      blurValue: 1,
      targetPadding: const EdgeInsets.all(4),
      targetBorderRadius: BorderRadius.circular(12),
      child: child,
    );
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

            final hasCompletedOnboarding = context.select(
              (OnboardingCubit cubit) => cubit.state.hasCompletedOnboarding,
            );
            final settingsState = context.watch<SettingsCubit>().state;
            final isViewVisible = TickerMode.valuesOf(context).enabled;

            _maybeStartShowcase(
              chartsState: state,
              settingsState: settingsState,
              hasCompletedOnboarding: hasCompletedOnboarding,
              isViewVisible: isViewVisible,
            );

            final isLoading = state.status == ChartsStatus.loading ||
                (state.status == ChartsStatus.initial &&
                    state.currencies.isEmpty);
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
                    fromCurrencyWrapper: (child) => _buildShowcase(
                      context,
                      key: _baseCurrencyShowcaseKey,
                      title: 'Default base',
                      description:
                          'Choose the base currency you want to track in the chart.',
                      child: child,
                    ),
                    swapButtonWrapper: (child) => _buildShowcase(
                      context,
                      key: _swapShowcaseKey,
                      title: 'Swap pair',
                      description:
                          'Reverse the chart pair instantly without reopening either dropdown.',
                      child: child,
                    ),
                    toCurrencyWrapper: (child) => _buildShowcase(
                      context,
                      key: _targetCurrencyShowcaseKey,
                      title: 'Compare currency',
                      description:
                          'Choose the other currency you want to compare against the base.',
                      child: child,
                    ),
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
                  _buildShowcase(
                    context,
                    key: _timeFrameShowcaseKey,
                    title: 'Time frame',
                    description:
                        'Change the chart range to compare short-term and long-term movement.',
                    child: RangeSelector(
                      ranges: const ['1W', '1M', '3M', '1Y', '5Y', '10Y'],
                      selectedRange: state.selectedRange,
                      onSelected: cubit.updateRange,
                      labelBuilder: (range) => _rangeShortLabel(l10n, range),
                    ),
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
