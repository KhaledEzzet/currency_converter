// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get flutter => 'Flutter';

  @override
  String get tabConvert => 'Umrechnen';

  @override
  String get tabCharts => 'Diagramme';

  @override
  String get tabSettings => 'Einstellungen';

  @override
  String get titleConverter => 'Währungsrechner';

  @override
  String get titleCharts => 'Diagramme';

  @override
  String get titleSettings => 'Einstellungen';

  @override
  String get labelFrom => 'Von';

  @override
  String get labelTo => 'Nach';

  @override
  String get labelLanguage => 'Sprache';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get languageArabic => 'Arabisch';

  @override
  String get languageFrench => 'Französisch';

  @override
  String get languageRussian => 'Russisch';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get languagePolish => 'Polnisch';

  @override
  String get errorGeneric => 'Etwas ist schiefgelaufen.';

  @override
  String get rangePastWeek => 'Letzte Woche';

  @override
  String get rangePastMonth => 'Letzter Monat';

  @override
  String get rangePastThreeMonths => 'Letzte 3 Monate';

  @override
  String get rangePastYear => 'Letztes Jahr';

  @override
  String get rangePastFiveYears => 'Letzte 5 Jahre';

  @override
  String get rangePastTenYears => 'Letzte 10 Jahre';

  @override
  String get rangeShortWeek => '1 W';

  @override
  String get rangeShortMonth => '1 M';

  @override
  String get rangeShortThreeMonths => '3 M';

  @override
  String get rangeShortYear => '1 J';

  @override
  String get rangeShortFiveYears => '5 J';

  @override
  String get rangeShortTenYears => '10 J';

  @override
  String get settingsDarkMode => 'Dunkelmodus';

  @override
  String get settingsOn => 'An';

  @override
  String get settingsOff => 'Aus';

  @override
  String get settingsGeneralTitle => 'Allgemein';

  @override
  String get settingsGeneralSubtitle => 'App-Verhalten und Einstellungen';

  @override
  String get settingsShowCurrencyFlags => 'Währungsflaggen anzeigen';

  @override
  String get settingsUseCurrencySymbols => 'Währungssymbole verwenden';

  @override
  String get settingsCurrenciesTitle => 'Währungen';

  @override
  String get settingsCurrenciesSubtitle => 'Standardbasis und Anzeigeoptionen';

  @override
  String get settingsDefaultBase => 'Standardbasis';

  @override
  String get settingsDisplayCurrencies => 'Angezeigte Währungen';

  @override
  String get settingsUnableToLoadCurrencies =>
      'Währungen konnten nicht geladen werden';

  @override
  String get settingsAllCurrencies => 'Alle Währungen';

  @override
  String get settingsNoCurrenciesSelected => 'Keine Währungen ausgewählt';

  @override
  String settingsSelectedCurrenciesMore(Object visible, Object remaining) {
    return '$visible +$remaining weitere';
  }

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsSelectAll => 'Alle auswählen';

  @override
  String get settingsClear => 'Leeren';

  @override
  String get settingsCancel => 'Abbrechen';

  @override
  String get settingsSave => 'Speichern';

  @override
  String get onboardingTitle => 'What\'s New';

  @override
  String get onboardingSubtitle =>
      'Convert instantly, compare multiple currencies, and follow exchange-rate trends in one place.';

  @override
  String get onboardingFeatureRatesTitle => 'Live exchange rates';

  @override
  String get onboardingFeatureRatesBody =>
      'Get up-to-date rates powered by Frankfurter every time you convert.';

  @override
  String get onboardingFeatureTrackingTitle => 'Multi-currency tracking';

  @override
  String get onboardingFeatureTrackingBody =>
      'Compare one base amount against the currencies you care about most.';

  @override
  String get onboardingFeatureChartsTitle => 'Historical charts';

  @override
  String get onboardingFeatureChartsBody =>
      'Explore price moves across 1W, 1M, 3M, 1Y, 5Y, and 10Y ranges.';

  @override
  String get onboardingFooter =>
      'Your base currency, display list, language, and theme are saved automatically.';

  @override
  String get onboardingContinue => 'Continue';
}
