// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get flutter => 'Flutter';

  @override
  String get tabConvert => 'Convert';

  @override
  String get tabCharts => 'Charts';

  @override
  String get tabSettings => 'Settings';

  @override
  String get titleConverter => 'Converter';

  @override
  String get titleCharts => 'Charts';

  @override
  String get titleSettings => 'Settings';

  @override
  String get labelFrom => 'From';

  @override
  String get labelTo => 'To';

  @override
  String get labelLanguage => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageFrench => 'French';

  @override
  String get languageRussian => 'Russian';

  @override
  String get languageGerman => 'German';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get languagePolish => 'Polish';

  @override
  String get errorGeneric => 'Something went wrong.';

  @override
  String get rangePastWeek => 'Past week';

  @override
  String get rangePastMonth => 'Past month';

  @override
  String get rangePastThreeMonths => 'Past 3 months';

  @override
  String get rangePastYear => 'Past year';

  @override
  String get rangePastFiveYears => 'Past 5 years';

  @override
  String get rangePastTenYears => 'Past 10 years';

  @override
  String get rangeShortWeek => '1W';

  @override
  String get rangeShortMonth => '1M';

  @override
  String get rangeShortThreeMonths => '3M';

  @override
  String get rangeShortYear => '1Y';

  @override
  String get rangeShortFiveYears => '5Y';

  @override
  String get rangeShortTenYears => '10Y';

  @override
  String get settingsDarkMode => 'Dark mode';

  @override
  String get settingsOn => 'On';

  @override
  String get settingsOff => 'Off';

  @override
  String get settingsGeneralTitle => 'General';

  @override
  String get settingsGeneralSubtitle => 'App behavior and preferences';

  @override
  String get settingsShowCurrencyFlags => 'Show currency flags';

  @override
  String get settingsUseCurrencySymbols => 'Use currency symbols';

  @override
  String get settingsCurrenciesTitle => 'Currencies';

  @override
  String get settingsCurrenciesSubtitle => 'Default base and display options';

  @override
  String get settingsDefaultBase => 'Default base';

  @override
  String get settingsDisplayCurrencies => 'Display currencies';

  @override
  String get settingsUnableToLoadCurrencies => 'Unable to load currencies';

  @override
  String get settingsAllCurrencies => 'All currencies';

  @override
  String get settingsNoCurrenciesSelected => 'No currencies selected';

  @override
  String settingsSelectedCurrenciesMore(Object visible, Object remaining) {
    return '$visible +$remaining more';
  }

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsSelectAll => 'Select all';

  @override
  String get settingsClear => 'Clear';

  @override
  String get settingsCancel => 'Cancel';

  @override
  String get settingsSave => 'Save';
}
