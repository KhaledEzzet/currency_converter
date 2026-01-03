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
}
