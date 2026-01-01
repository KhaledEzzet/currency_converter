import 'package:currency_converter/app/constants/string_constants.dart';
import 'package:currency_converter/app/l10n/arb/app_localizations.dart';
import 'package:currency_converter/app/l10n/cubit/locale_cubit.dart';
import 'package:currency_converter/app/router/app_router.dart';
import 'package:currency_converter/app/theme/dark/dark_theme.dart';
import 'package:currency_converter/app/theme/light/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  App({super.key});

  final _appRouter = AppRouter();

  Locale _resolveInitialLocale() {
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    for (final supportedLocale in AppLocalizations.supportedLocales) {
      if (supportedLocale.languageCode == deviceLocale.languageCode) {
        return Locale(supportedLocale.languageCode);
      }
    }
    return const Locale('en');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocaleCubit(initialLocale: _resolveInitialLocale()),
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            // App Name
            title: StringConstants.appName,

            // Theme
            theme: LightTheme().theme,
            darkTheme: DarkTheme().theme,

            // Localization
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,

            // Routing
            routerConfig: _appRouter.router,
          );
        },
      ),
    );
  }
}
