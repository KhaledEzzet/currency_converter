import 'package:currency_converter/app/constants/string_constants.dart';
import 'package:currency_converter/app/l10n/arb/app_localizations.dart';
import 'package:currency_converter/app/router/app_router.dart';
import 'package:flutter/material.dart';

import 'package:currency_converter/app/router/custom_route_observer.dart';
import 'package:currency_converter/app/theme/dark/dark_theme.dart';
import 'package:currency_converter/app/theme/light/light_theme.dart';

class App extends StatelessWidget {
  App({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // App Name
      title: StringConstants.appName,

      // Theme
      theme: LightTheme().theme,
      darkTheme: DarkTheme().theme,

      // Localization
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      // Routing
      routerConfig: _appRouter.config(
        navigatorObservers: () => [CustomRouteObserver()],
      ),
    );
  }
}
