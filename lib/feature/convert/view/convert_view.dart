import 'package:currency_converter/app/l10n/l10n.dart';
import 'package:currency_converter/feature/convert/cubit/convert_cubit.dart';
import 'package:currency_converter/feature/convert/cubit/convert_state.dart';
import 'package:currency_converter/feature/convert/view/widgets/from_row.dart';
import 'package:currency_converter/feature/convert/view/widgets/section_title.dart';
import 'package:currency_converter/feature/convert/view/widgets/to_list.dart';
import 'package:currency_converter/feature/settings/cubit/settings_cubit.dart';
import 'package:currency_converter/feature/settings/cubit/settings_state.dart';
import 'package:currency_converter/feature/settings/view/widgets/display_currencies_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

extension _CurrencySortOptionLabel on CurrencySortOption {
  String get label {
    switch (this) {
      case CurrencySortOption.alphabeticalAsc:
        return 'A to Z';
      case CurrencySortOption.alphabeticalDesc:
        return 'Z to A';
      case CurrencySortOption.lowPrice:
        return 'Low price';
      case CurrencySortOption.highPrice:
        return 'High price';
    }
  }

  String get buttonLabel {
    switch (this) {
      case CurrencySortOption.alphabeticalAsc:
        return 'A-Z';
      case CurrencySortOption.alphabeticalDesc:
        return 'Z-A';
      case CurrencySortOption.lowPrice:
        return 'Low';
      case CurrencySortOption.highPrice:
        return 'High';
    }
  }
}

class ConvertView extends StatelessWidget {
  const ConvertView({super.key});

  List<String> _sortedCurrencies({
    required List<String> currencies,
    required Map<String, double> values,
    required CurrencySortOption sortOption,
  }) {
    final sorted = [...currencies];

    switch (sortOption) {
      case CurrencySortOption.alphabeticalAsc:
        sorted.sort((a, b) => a.compareTo(b));
      case CurrencySortOption.alphabeticalDesc:
        sorted.sort((a, b) => b.compareTo(a));
      case CurrencySortOption.lowPrice:
        sorted.sort(
          (a, b) => _compareByValue(
            a,
            b,
            values,
            ascending: true,
          ),
        );
      case CurrencySortOption.highPrice:
        sorted.sort(
          (a, b) => _compareByValue(
            a,
            b,
            values,
            ascending: false,
          ),
        );
    }

    return sorted;
  }

  int _compareByValue(
    String first,
    String second,
    Map<String, double> values, {
    required bool ascending,
  }) {
    final firstRate = values[first];
    final secondRate = values[second];

    if (firstRate == null && secondRate == null) {
      return first.compareTo(second);
    }
    if (firstRate == null) {
      return 1;
    }
    if (secondRate == null) {
      return -1;
    }

    final byRate = firstRate.compareTo(secondRate);
    if (byRate == 0) {
      return first.compareTo(second);
    }

    return ascending ? byRate : -byRate;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.titleConverter,
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
          if (settingsState.baseCurrency !=
              context.read<ConvertCubit>().state.fromCurrency) {
            context
                .read<ConvertCubit>()
                .updateFromCurrency(settingsState.baseCurrency);
          }
        },
        child: BlocBuilder<ConvertCubit, ConvertState>(
          builder: (context, state) {
            if (state.status == ConvertStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.status == ConvertStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage ?? l10n.errorGeneric,
                ),
              );
            }

            final settingsState = context.watch<SettingsCubit>().state;
            final displayCurrencies = settingsState.displaySelectionInitialized
                ? () {
                    final selected = settingsState.displayCurrencies.toSet();
                    return state.currencies.where(selected.contains).toList();
                  }()
                : state.currencies;
            final showCurrencyFlags = settingsState.showCurrencyFlags;
            final useCurrencySymbols = settingsState.useCurrencySymbols;
            final targetCurrencies = displayCurrencies
                .where((currency) => currency != state.fromCurrency)
                .toList();
            final sortValues = state.convertedAmounts.isNotEmpty
                ? state.convertedAmounts
                : state.currencyRates;
            final sortedTargetCurrencies = _sortedCurrencies(
              currencies: targetCurrencies,
              values: sortValues,
              sortOption: state.sortOption,
            );

            return Padding(
              padding: const EdgeInsets.all(16),
              child: FormBuilder(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(text: l10n.labelFrom),
                    const SizedBox(height: 20),
                    FromRow(
                      state: state,
                      showCurrencyFlags: showCurrencyFlags,
                      useCurrencySymbols: useCurrencySymbols,
                      onCurrencyChanged: (currency) {
                        if (currency == null) {
                          return;
                        }
                        context
                            .read<SettingsCubit>()
                            .updateBaseCurrency(currency);
                      },
                      onAmountChanged: (value) =>
                          context.read<ConvertCubit>().updateAmount(value),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: SectionTitle(text: l10n.labelTo),
                        ),
                        SizedBox(
                          width: 92,
                          height: 34,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: DropdownButton<CurrencySortOption>(
                                value: state.sortOption,
                                isExpanded: true,
                                isDense: true,
                                alignment: Alignment.center,
                                underline: const SizedBox.shrink(),
                                iconSize: 18,
                                borderRadius: BorderRadius.circular(10),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                items: CurrencySortOption.values
                                    .map(
                                      (option) =>
                                          DropdownMenuItem<CurrencySortOption>(
                                        value: option,
                                        child: Center(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2),
                                            child: Text(
                                              option.label,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                selectedItemBuilder: (context) {
                                  return CurrencySortOption.values
                                      .map(
                                        (option) => Center(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2),
                                            child: Text(
                                              option.buttonLabel,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList();
                                },
                                onChanged: (option) {
                                  if (option == null) {
                                    return;
                                  }
                                  context
                                      .read<ConvertCubit>()
                                      .updateSortOption(option);
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          onPressed: settingsState.currencies.isNotEmpty
                              ? () => showDisplayCurrenciesSheet(
                                    context,
                                    settingsState,
                                  )
                              : null,
                          tooltip: l10n.settingsDisplayCurrencies,
                          icon: const Icon(Icons.view_list),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: sortedTargetCurrencies.isEmpty
                          ? const Center(
                              child: Text(
                                'No display currencies selected.',
                              ),
                            )
                          : ToList(
                              state: state,
                              currencies: sortedTargetCurrencies,
                              showCurrencyFlags: showCurrencyFlags,
                              useCurrencySymbols: useCurrencySymbols,
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
