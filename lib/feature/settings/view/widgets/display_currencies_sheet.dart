import 'package:currency_converter/feature/convert/view/widgets/currency_flag.dart';
import 'package:currency_converter/feature/settings/cubit/settings_cubit.dart';
import 'package:currency_converter/feature/settings/cubit/settings_state.dart';
import 'package:currency_converter/app/l10n/arb/app_localizations.dart';
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

Widget buildCurrencyLabel(String currency, bool showFlags) {
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
    builder: (context) {
      final theme = Theme.of(context);
      final l10n = AppLocalizations.of(context);
      return SafeArea(
        child: StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settingsDisplayCurrencies,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setSheetState(() {
                              selected
                                ..clear()
                                ..addAll(state.currencies);
                            });
                          },
                          child: Text(l10n.settingsSelectAll),
                        ),
                        TextButton(
                          onPressed: () {
                            setSheetState(() {
                              selected.clear();
                            });
                          },
                          child: Text(l10n.settingsClear),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.currencies.length,
                        itemBuilder: (context, index) {
                          final currency = state.currencies[index];
                          return CheckboxListTile(
                            value: selected.contains(currency),
                            title: buildCurrencyLabel(
                              currency,
                              state.showCurrencyFlags,
                            ),
                            onChanged: (value) {
                              setSheetState(() {
                                if (value == true) {
                                  selected.add(currency);
                                } else {
                                  selected.remove(currency);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.settingsCancel),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<SettingsCubit>()
                                .updateDisplayCurrencies(selected.toList());
                            Navigator.pop(context);
                          },
                          child: Text(l10n.settingsSave),
                        ),
                      ],
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
