import 'package:currency_converter/app/l10n/arb/app_localizations.dart';
import 'package:currency_converter/app/l10n/cubit/locale_cubit.dart';
import 'package:currency_converter/app/theme/cubit/theme_cubit.dart';
import 'package:currency_converter/core/utils/package_info/package_info_utils.dart';
import 'package:currency_converter/feature/settings/cubit/settings_cubit.dart';
import 'package:currency_converter/feature/settings/cubit/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  String _languageLabel(AppLocalizations l10n, Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return l10n.languageArabic;
      case 'en':
        return l10n.languageEnglish;
      default:
        return locale.languageCode;
    }
  }

  String _displaySelectionLabel(SettingsState state) {
    if (!state.displaySelectionInitialized) {
      return 'All currencies';
    }
    if (state.displayCurrencies.isEmpty) {
      return 'No currencies selected';
    }
    if (state.displayCurrencies.length <= 3) {
      return state.displayCurrencies.join(', ');
    }
    final visible = state.displayCurrencies.take(3).join(', ');
    final remaining = state.displayCurrencies.length - 3;
    return '$visible +$remaining more';
  }

  void _showDisplayCurrenciesSheet(
    BuildContext context,
    SettingsState state,
  ) {
    final selected = state.displaySelectionInitialized
        ? state.displayCurrencies.toSet()
        : state.currencies.toSet();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final theme = Theme.of(context);
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
                        'Display currencies',
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
                            child: const Text('Select all'),
                          ),
                          TextButton(
                            onPressed: () {
                              setSheetState(() {
                                selected.clear();
                              });
                            },
                            child: const Text('Clear'),
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
                              title: Text(currency),
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
                            child: const Text('Cancel'),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<SettingsCubit>()
                                  .updateDisplayCurrencies(selected.toList());
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appVersion = PackageInfoUtils.getAppVersion();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.titleSettings,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isDarkMode = themeMode == ThemeMode.dark;
              return SwitchListTile(
                value: isDarkMode,
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                secondary: const Icon(Icons.dark_mode),
                title: const Text('Dark mode'),
                subtitle: Text(isDarkMode ? 'On' : 'Off'),
              );
            },
          ),
          const Divider(height: 24),
          BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              final currentLocale = Locale(locale.languageCode);
              return ListTile(
                leading: const Icon(Icons.language),
                title: Text(l10n.labelLanguage),
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<Locale>(
                    value: currentLocale,
                    isDense: true,
                    items: AppLocalizations.supportedLocales.map((supported) {
                      return DropdownMenuItem(
                        value: supported,
                        child: Text(_languageLabel(l10n, supported)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      context.read<LocaleCubit>().updateLocale(value);
                    },
                  ),
                ),
              );
            },
          ),
          const Divider(height: 24),
          const ListTile(
            leading: Icon(Icons.tune),
            title: Text('General'),
            subtitle: Text('App behavior and preferences'),
          ),
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return Column(
                children: [
                  SwitchListTile(
                    value: state.showCurrencyFlags,
                    onChanged: (value) {
                      context
                          .read<SettingsCubit>()
                          .updateShowCurrencyFlags(value);
                    },
                    secondary: const Icon(Icons.flag_outlined),
                    title: const Text('Show currency flags'),
                    subtitle: Text(state.showCurrencyFlags ? 'On' : 'Off'),
                  ),
                  SwitchListTile(
                    value: state.useCurrencySymbols,
                    onChanged: (value) {
                      context
                          .read<SettingsCubit>()
                          .updateUseCurrencySymbols(value);
                    },
                    secondary: const Icon(Icons.payments_outlined),
                    title: const Text('Use currency symbols'),
                    subtitle: Text(state.useCurrencySymbols ? 'On' : 'Off'),
                  ),
                ],
              );
            },
          ),
          const Divider(height: 24),
          const ListTile(
            leading: Icon(Icons.currency_exchange),
            title: Text('Currencies'),
            subtitle: Text('Default base and display options'),
          ),
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              final hasCurrencies = state.currencies.isNotEmpty;
              if (state.status == SettingsStatus.loading && !hasCurrencies) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state.status == SettingsStatus.failure && !hasCurrencies) {
                return ListTile(
                  leading: const Icon(Icons.error_outline),
                  title: const Text('Unable to load currencies'),
                  subtitle: Text(state.errorMessage ?? l10n.errorGeneric),
                );
              }

              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet),
                    title: const Text('Default base'),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: hasCurrencies &&
                                state.currencies.contains(state.baseCurrency)
                            ? state.baseCurrency
                            : null,
                        isDense: true,
                        items: state.currencies
                            .map(
                              (currency) => DropdownMenuItem<String>(
                                value: currency,
                                child: Text(currency),
                              ),
                            )
                            .toList(),
                        onChanged: hasCurrencies
                            ? context.read<SettingsCubit>().updateBaseCurrency
                            : null,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.view_list),
                    title: const Text('Display currencies'),
                    subtitle: Text(_displaySelectionLabel(state)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: hasCurrencies
                        ? () => _showDisplayCurrenciesSheet(context, state)
                        : null,
                  ),
                ],
              );
            },
          ),
          const Divider(height: 24),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Version'),
            subtitle: Text(appVersion),
          ),
        ],
      ),
    );
  }
}
