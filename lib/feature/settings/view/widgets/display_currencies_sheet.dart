import 'package:currency_converter/app/l10n/arb/app_localizations.dart';
import 'package:currency_converter/feature/convert/view/widgets/currency_flag.dart';
import 'package:currency_converter/feature/settings/cubit/settings_cubit.dart';
import 'package:currency_converter/feature/settings/cubit/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String _currencyFlagCode(String currency) {
  if (currency == 'EUR') {
    return 'eu';
  }
  if (currency.length < 2) {
    return '';
  }
  return currency.substring(0, 2).toLowerCase();
}

Widget buildCurrencyLabel(String currency, {required bool showFlags}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (showFlags) ...[
        CurrencyFlag(code: _currencyFlagCode(currency)),
        const SizedBox(width: 8),
      ],
      Text(currency),
    ],
  );
}

Future<void> showDisplayCurrenciesSheet(
  BuildContext context,
  SettingsState state,
) {
  final selected = state.displaySelectionInitialized
      ? state.displayCurrencies.toSet()
      : state.currencies.toSet();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final l10n = AppLocalizations.of(context);
      return SafeArea(
        child: StatefulBuilder(
          builder: (context, setSheetState) {
            final selectedCount = selected.length;
            final totalCount = state.currencies.length;
            final allSelected = selectedCount == totalCount && totalCount > 0;
            final hasSelection = selectedCount > 0;

            void updateCurrencySelection({
              required String currency,
              required bool isSelected,
            }) {
              setSheetState(() {
                if (isSelected) {
                  selected.add(currency);
                } else {
                  selected.remove(currency);
                }
              });
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.78,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.55),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.settingsDisplayCurrencies,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest
                                        .withValues(
                                      alpha: theme.brightness == Brightness.dark
                                          ? 0.35
                                          : 0.7,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    allSelected
                                        ? l10n.settingsAllCurrencies
                                        : hasSelection
                                            ? '$selectedCount/$totalCount'
                                            : l10n.settingsNoCurrenciesSelected,
                                    style: theme.textTheme.labelLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: allSelected
                                  ? null
                                  : () {
                                      setSheetState(() {
                                        selected
                                          ..clear()
                                          ..addAll(state.currencies);
                                      });
                                    },
                              child: Text(l10n.settingsSelectAll),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: hasSelection
                                  ? () {
                                      setSheetState(selected.clear);
                                    }
                                  : null,
                              child: Text(l10n.settingsClear),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: state.currencies.isEmpty
                          ? Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  l10n.settingsUnableToLoadCurrencies,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: state.currencies.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final currency = state.currencies[index];
                                final isSelected = selected.contains(currency);
                                return Material(
                                  color: Colors.transparent,
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? colorScheme.primaryContainer
                                              .withValues(
                                              alpha: theme.brightness ==
                                                      Brightness.dark
                                                  ? 0.45
                                                  : 0.6,
                                            )
                                          : colorScheme.surfaceContainerLowest
                                              .withValues(
                                              alpha: theme.brightness ==
                                                      Brightness.dark
                                                  ? 0.18
                                                  : 0.5,
                                            ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected
                                            ? colorScheme.primary
                                                .withValues(alpha: 0.4)
                                            : colorScheme.outlineVariant
                                                .withValues(alpha: 0.7),
                                      ),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () => updateCurrencySelection(
                                        currency: currency,
                                        isSelected: !isSelected,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: DefaultTextStyle.merge(
                                                style: theme
                                                        .textTheme.titleMedium
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ) ??
                                                    const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                child: buildCurrencyLabel(
                                                  currency,
                                                  showFlags:
                                                      state.showCurrencyFlags,
                                                ),
                                              ),
                                            ),
                                            Checkbox(
                                              value: isSelected,
                                              onChanged: (value) =>
                                                  updateCurrencySelection(
                                                currency: currency,
                                                isSelected: value ?? false,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(l10n.settingsCancel),
                          ),
                          const Spacer(),
                          FilledButton(
                            onPressed: () {
                              final orderedSelection = state.currencies
                                  .where(selected.contains)
                                  .toList();
                              context
                                  .read<SettingsCubit>()
                                  .updateDisplayCurrencies(orderedSelection);
                              Navigator.pop(context);
                            },
                            child: Text(l10n.settingsSave),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
