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

  String _displaySelectionLabel(AppLocalizations l10n, SettingsState state) {
    if (!state.displaySelectionInitialized) {
      return l10n.settingsAllCurrencies;
    }
    if (state.displayCurrencies.isEmpty) {
      return l10n.settingsNoCurrenciesSelected;
    }
    if (state.displayCurrencies.length <= 3) {
      return state.displayCurrencies.join(', ');
    }
    final visible = state.displayCurrencies.take(3).join(', ');
    final remaining = state.displayCurrencies.length - 3;
    return l10n.settingsSelectedCurrenciesMore(visible, remaining);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appVersion = PackageInfoUtils.getAppVersion();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.titleSettings,
          style: const TextStyle(
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
                title: Text(l10n.settingsDarkMode),
                subtitle: Text(isDarkMode ? l10n.settingsOn : l10n.settingsOff),
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
          ListTile(
            leading: const Icon(Icons.tune),
            title: Text(l10n.settingsGeneralTitle),
            subtitle: Text(l10n.settingsGeneralSubtitle),
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
                    title: Text(l10n.settingsShowCurrencyFlags),
                    subtitle: Text(
                      state.showCurrencyFlags
                          ? l10n.settingsOn
                          : l10n.settingsOff,
                    ),
                  ),
                  SwitchListTile(
                    value: state.useCurrencySymbols,
                    onChanged: (value) {
                      context
                          .read<SettingsCubit>()
                          .updateUseCurrencySymbols(value);
                    },
                    secondary: const Icon(Icons.payments_outlined),
                    title: Text(l10n.settingsUseCurrencySymbols),
                    subtitle: Text(
                      state.useCurrencySymbols
                          ? l10n.settingsOn
                          : l10n.settingsOff,
                    ),
                  ),
                ],
              );
            },
          ),
          const Divider(height: 24),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: Text(l10n.settingsCurrenciesTitle),
            subtitle: Text(l10n.settingsCurrenciesSubtitle),
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
                  title: Text(l10n.settingsUnableToLoadCurrencies),
                  subtitle: Text(state.errorMessage ?? l10n.errorGeneric),
                );
              }

              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet),
                    title: Text(l10n.settingsDefaultBase),
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
                                  showFlags: state.showCurrencyFlags,
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
                    title: Text(l10n.settingsDisplayCurrencies),
                    subtitle: Text(_displaySelectionLabel(l10n, state)),
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
            title: Text(l10n.settingsVersion),
            subtitle: Text(appVersion),
          ),
        ],
      ),
    );
  }
}
