import 'package:currency_converter/app/l10n/arb/app_localizations.dart';
import 'package:currency_converter/app/l10n/cubit/locale_cubit.dart';
import 'package:currency_converter/app/theme/cubit/theme_cubit.dart';
import 'package:currency_converter/core/utils/package_info/package_info_utils.dart';
import 'package:currency_converter/feature/convert/view/widgets/currency_flag.dart';
import 'package:currency_converter/feature/settings/cubit/settings_cubit.dart';
import 'package:currency_converter/feature/settings/cubit/settings_state.dart';
import 'package:currency_converter/feature/settings/view/widgets/display_currencies_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  String _languageLabel(AppLocalizations l10n, Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return l10n.languageArabic;
      case 'de':
        return l10n.languageGerman;
      case 'en':
        return l10n.languageEnglish;
      case 'fr':
        return l10n.languageFrench;
      case 'hi':
        return l10n.languageHindi;
      case 'pl':
        return l10n.languagePolish;
      case 'ru':
        return l10n.languageRussian;
      default:
        return locale.languageCode;
    }
  }

  String? _languageFlagCode(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return 'sa';
      case 'de':
        return 'de';
      case 'en':
        return 'us';
      case 'fr':
        return 'fr';
      case 'hi':
        return 'in';
      case 'pl':
        return 'pl';
      case 'ru':
        return 'ru';
      default:
        return null;
    }
  }

  Widget _buildLanguageLabel(AppLocalizations l10n, Locale locale) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CurrencyFlag(code: _languageFlagCode(locale)),
        const SizedBox(width: 8),
        Text(_languageLabel(l10n, locale)),
      ],
    );
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
                        child: _buildLanguageLabel(l10n, supported),
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
                                child: buildCurrencyLabel(
                                  currency,
                                  state.showCurrencyFlags,
                                ),
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
                        ? () => showDisplayCurrenciesSheet(context, state)
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
