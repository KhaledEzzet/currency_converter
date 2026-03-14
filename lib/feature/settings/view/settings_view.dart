import 'package:currency_converter/app/constants/string_constants.dart';
import 'package:currency_converter/app/l10n/arb/app_localizations.dart';
import 'package:currency_converter/app/l10n/cubit/locale_cubit.dart';
import 'package:currency_converter/app/theme/cubit/theme_cubit.dart';
import 'package:currency_converter/core/utils/browser/open_url_in_new_tab.dart';
import 'package:currency_converter/core/utils/feedback/feedback_utils.dart';
import 'package:currency_converter/core/utils/logger/logger_utils.dart';
import 'package:currency_converter/core/utils/package_info/package_info_utils.dart';
import 'package:currency_converter/feature/convert/view/widgets/currency_flag.dart';
import 'package:currency_converter/feature/onboarding/cubit/onboarding_cubit.dart';
import 'package:currency_converter/feature/settings/cubit/settings_cubit.dart';
import 'package:currency_converter/feature/settings/cubit/settings_state.dart';
import 'package:currency_converter/feature/settings/view/widgets/display_currencies_sheet.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  static const _showcaseScope = 'settings_view_showcase';

  final GlobalKey _darkModeShowcaseKey = GlobalKey();
  final GlobalKey _languageShowcaseKey = GlobalKey();
  final GlobalKey _currencyFlagsShowcaseKey = GlobalKey();
  final GlobalKey _currencySymbolsShowcaseKey = GlobalKey();
  final GlobalKey _defaultBaseShowcaseKey = GlobalKey();

  late final ShowcaseView _showcaseView;
  bool _showcaseScheduled = false;

  @override
  void initState() {
    super.initState();
    _showcaseView = ShowcaseView.register(
      scope: _showcaseScope,
      enableAutoScroll: true,
      onFinish: _markSettingsShowcaseSeen,
      onDismiss: (_) => _markSettingsShowcaseSeen(),
      globalTooltipActionConfig: const TooltipActionConfig(),
      globalTooltipActions: const [
        TooltipActionButton(type: TooltipDefaultActionType.skip),
        TooltipActionButton(type: TooltipDefaultActionType.next),
      ],
    );
  }

  @override
  void dispose() {
    _showcaseView.unregister();
    super.dispose();
  }

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

  Future<void> _openFeedbackFlow(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final localeTag = Localizations.maybeLocaleOf(context)?.toLanguageTag();
    final sharedMessage = l10n.settingsFeedbackShared;
    final shareFailedMessage = l10n.settingsFeedbackShareFailed;

    BetterFeedback.of(context).show((feedback) async {
      try {
        final didOpenComposer = await FeedbackUtils.composeFeedbackEmail(
          feedback: feedback,
          localeTag: localeTag,
        );
        if (!didOpenComposer || !scaffoldMessenger.mounted) {
          return;
        }

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(sharedMessage),
          ),
        );
      } catch (error) {
        LoggerUtils.instance.logError('Unable to share feedback: $error');
        if (!scaffoldMessenger.mounted) {
          return;
        }

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(shareFailedMessage),
          ),
        );
      }
    });
  }

  Future<void> _openReviewPage(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final didOpen = await openUrlInNewTab(
        StringConstants.chromeWebStoreReviewsUrl,
      );
      if (didOpen || !scaffoldMessenger.mounted) {
        return;
      }
    } catch (error) {
      LoggerUtils.instance.logError('Unable to open review page: $error');
      if (!scaffoldMessenger.mounted) {
        return;
      }
    }

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(l10n.settingsLeaveReviewOpenFailed),
      ),
    );
  }

  void _markSettingsShowcaseSeen() {
    if (!mounted) {
      return;
    }
    context.read<SettingsCubit>().markSettingsShowcaseSeen();
  }

  void _maybeStartShowcase({
    required SettingsState settingsState,
    required bool hasCompletedOnboarding,
    required bool isRouteVisible,
  }) {
    if (_showcaseScheduled ||
        !hasCompletedOnboarding ||
        !isRouteVisible ||
        settingsState.status != SettingsStatus.success ||
        settingsState.currencies.isEmpty ||
        settingsState.settingsShowcaseSeen) {
      return;
    }

    _showcaseScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _showcaseView.startShowCase(
        [
          _darkModeShowcaseKey,
          _languageShowcaseKey,
          _currencyFlagsShowcaseKey,
          _currencySymbolsShowcaseKey,
          _defaultBaseShowcaseKey,
        ],
        delay: const Duration(milliseconds: 300),
      );
    });
  }

  Widget _buildShowcase(
    BuildContext context, {
    required GlobalKey key,
    required String title,
    required String description,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Showcase(
      key: key,
      title: title,
      description: description,
      tooltipBackgroundColor: colorScheme.surface,
      textColor: colorScheme.onSurface,
      titleTextStyle: theme.textTheme.titleMedium?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
      descTextStyle: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
        height: 1.4,
      ),
      overlayOpacity: 0.72,
      blurValue: 1,
      targetPadding: const EdgeInsets.all(4),
      targetBorderRadius: BorderRadius.circular(12),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appVersion = PackageInfoUtils.getAppVersion();
    final settingsState = context.watch<SettingsCubit>().state;
    final hasCompletedOnboarding = context.select(
      (OnboardingCubit cubit) => cubit.state.hasCompletedOnboarding,
    );
    final isRouteVisible = ModalRoute.of(context)?.isCurrent ?? true;

    _maybeStartShowcase(
      settingsState: settingsState,
      hasCompletedOnboarding: hasCompletedOnboarding,
      isRouteVisible: isRouteVisible,
    );

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
              return _buildShowcase(
                context,
                key: _darkModeShowcaseKey,
                title: 'Dark mode',
                description:
                    'Switch the app between light and dark appearance.',
                child: SwitchListTile(
                  value: isDarkMode,
                  onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                  secondary: const Icon(Icons.dark_mode),
                  title: Text(l10n.settingsDarkMode),
                  subtitle:
                      Text(isDarkMode ? l10n.settingsOn : l10n.settingsOff),
                ),
              );
            },
          ),
          const Divider(height: 24),
          BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              final currentLocale = Locale(locale.languageCode);
              return _buildShowcase(
                context,
                key: _languageShowcaseKey,
                title: 'Language',
                description: 'Choose the language used across the app.',
                child: ListTile(
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
          Column(
            children: [
              _buildShowcase(
                context,
                key: _currencyFlagsShowcaseKey,
                title: 'Currency flags',
                description:
                    'Show or hide country flags beside currencies in dropdowns and lists.',
                child: SwitchListTile(
                  value: settingsState.showCurrencyFlags,
                  onChanged: (value) {
                    context
                        .read<SettingsCubit>()
                        .updateShowCurrencyFlags(value: value);
                  },
                  secondary: const Icon(Icons.flag_outlined),
                  title: Text(l10n.settingsShowCurrencyFlags),
                  subtitle: Text(
                    settingsState.showCurrencyFlags
                        ? l10n.settingsOn
                        : l10n.settingsOff,
                  ),
                ),
              ),
              _buildShowcase(
                context,
                key: _currencySymbolsShowcaseKey,
                title: 'Currency symbols',
                description:
                    r'Use symbols like $ and € instead of currency codes when available.',
                child: SwitchListTile(
                  value: settingsState.useCurrencySymbols,
                  onChanged: (value) {
                    context
                        .read<SettingsCubit>()
                        .updateUseCurrencySymbols(value: value);
                  },
                  secondary: const Icon(Icons.payments_outlined),
                  title: Text(l10n.settingsUseCurrencySymbols),
                  subtitle: Text(
                    settingsState.useCurrencySymbols
                        ? l10n.settingsOn
                        : l10n.settingsOff,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: Text(l10n.settingsCurrenciesTitle),
            subtitle: Text(l10n.settingsCurrenciesSubtitle),
          ),
          if (settingsState.status == SettingsStatus.loading &&
              settingsState.currencies.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (settingsState.status == SettingsStatus.failure &&
              settingsState.currencies.isEmpty)
            ListTile(
              leading: const Icon(Icons.error_outline),
              title: Text(l10n.settingsUnableToLoadCurrencies),
              subtitle: Text(settingsState.errorMessage ?? l10n.errorGeneric),
            )
          else
            Column(
              children: [
                _buildShowcase(
                  context,
                  key: _defaultBaseShowcaseKey,
                  title: 'Default base',
                  description:
                      'Choose the default base currency used in convert and charts.',
                  child: ListTile(
                    leading: const Icon(Icons.account_balance_wallet),
                    title: Text(l10n.settingsDefaultBase),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: settingsState.currencies.contains(
                          settingsState.baseCurrency,
                        )
                            ? settingsState.baseCurrency
                            : null,
                        isDense: true,
                        items: settingsState.currencies
                            .map(
                              (currency) => DropdownMenuItem<String>(
                                value: currency,
                                child: buildCurrencyLabel(
                                  currency,
                                  showFlags: settingsState.showCurrencyFlags,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged:
                            context.read<SettingsCubit>().updateBaseCurrency,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.view_list),
                  title: Text(l10n.settingsDisplayCurrencies),
                  subtitle: Text(_displaySelectionLabel(l10n, settingsState)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      showDisplayCurrenciesSheet(context, settingsState),
                ),
              ],
            ),
          const Divider(height: 24),
          ListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: Text(l10n.settingsSendFeedback),
            subtitle: Text(l10n.settingsSendFeedbackSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openFeedbackFlow(context),
          ),
          if (kIsWeb) ...[
            const Divider(height: 24),
            ListTile(
              leading: const Icon(Icons.star_outline),
              title: Text(l10n.settingsLeaveReview),
              subtitle: Text(l10n.settingsLeaveReviewSubtitle),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _openReviewPage(context),
            ),
          ],
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
