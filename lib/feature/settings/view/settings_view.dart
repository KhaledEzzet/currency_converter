import 'package:currency_converter/app/l10n/arb/app_localizations.dart';
import 'package:currency_converter/app/l10n/cubit/locale_cubit.dart';
import 'package:currency_converter/app/theme/cubit/theme_cubit.dart';
import 'package:currency_converter/core/utils/package_info/package_info_utils.dart';
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
          const Divider(height: 24),
          const ListTile(
            leading: Icon(Icons.currency_exchange),
            title: Text('Currencies'),
            subtitle: Text('Default base and display options'),
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
