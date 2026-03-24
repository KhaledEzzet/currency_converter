import 'package:currency_converter/app/constants/string_constants.dart';
import 'package:currency_converter/app/l10n/arb/app_localizations.dart';
import 'package:currency_converter/app/l10n/cubit/locale_cubit.dart';
import 'package:currency_converter/app/router/app_router.dart';
import 'package:currency_converter/app/theme/cubit/theme_cubit.dart';
import 'package:currency_converter/app/theme/dark/dark_theme.dart';
import 'package:currency_converter/app/theme/light/light_theme.dart';
import 'package:currency_converter/feature/onboarding/cubit/onboarding_cubit.dart';
import 'package:currency_converter/feature/onboarding/view/onboarding_view.dart';
import 'package:feedback/feedback.dart';
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

  List<Color> _buildFeedbackDrawColors(ColorScheme colorScheme) {
    // The feedback package keys swatches by color value, so duplicates in the
    // active theme crash the picker. Dark theme currently reuses one accent.
    final uniqueColors = <Color>[];
    final candidates = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.error,
      colorScheme.inversePrimary,
      colorScheme.onSurface,
    ];

    for (final color in candidates) {
      if (uniqueColors.contains(color)) {
        continue;
      }
      uniqueColors.add(color);
    }

    return uniqueColors;
  }

  FeedbackThemeData _buildFeedbackTheme(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final onSurfaceColor = colorScheme.onSurface;

    return FeedbackThemeData(
      background: colorScheme.outlineVariant,
      feedbackSheetColor: colorScheme.surface,
      activeFeedbackModeColor: colorScheme.primary,
      drawColors: _buildFeedbackDrawColors(colorScheme),
      bottomSheetDescriptionStyle: theme.textTheme.titleMedium?.copyWith(
            color: onSurfaceColor,
          ) ??
          TextStyle(color: onSurfaceColor),
      bottomSheetTextInputStyle: theme.textTheme.bodyLarge?.copyWith(
            color: onSurfaceColor,
          ) ??
          TextStyle(color: onSurfaceColor),
      colorScheme: colorScheme,
      brightness: theme.brightness,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LocaleCubit(initialLocale: _resolveInitialLocale()),
        ),
        BlocProvider(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider(
          create: (_) => OnboardingCubit(),
        ),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final lightTheme = LightTheme().theme;
              final darkTheme = DarkTheme().theme;

              return BetterFeedback(
                themeMode: themeMode,
                theme: _buildFeedbackTheme(lightTheme),
                darkTheme: _buildFeedbackTheme(darkTheme),
                localeOverride: locale,
                localizationsDelegates: [
                  ...AppLocalizations.localizationsDelegates,
                  GlobalFeedbackLocalizationsDelegate.delegate,
                ],
                child: MaterialApp.router(
                  // App Name
                  title: StringConstants.appName,
                  debugShowCheckedModeBanner: false,

                  // Theme
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  themeMode: themeMode,

                  // Localization
                  locale: locale,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,

                  // Routing
                  routerConfig: _appRouter.router,
                  builder: (context, child) {
                    return OnboardingGate(child: child);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
