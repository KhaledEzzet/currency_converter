// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get flutter => 'Flutter';

  @override
  String get tabConvert => 'Przelicz';

  @override
  String get tabCharts => 'Wykresy';

  @override
  String get tabSettings => 'Ustawienia';

  @override
  String get titleConverter => 'Przelicznik';

  @override
  String get titleCharts => 'Wykresy';

  @override
  String get titleSettings => 'Ustawienia';

  @override
  String get labelFrom => 'Z';

  @override
  String get labelTo => 'Na';

  @override
  String get labelLanguage => 'Język';

  @override
  String get languageEnglish => 'Angielski';

  @override
  String get languageArabic => 'Arabski';

  @override
  String get languageFrench => 'Francuski';

  @override
  String get languageRussian => 'Rosyjski';

  @override
  String get languageGerman => 'Niemiecki';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get languagePolish => 'Polski';

  @override
  String get errorGeneric => 'Coś poszło nie tak.';

  @override
  String get rangePastWeek => 'Ostatni tydzień';

  @override
  String get rangePastMonth => 'Ostatni miesiąc';

  @override
  String get rangePastThreeMonths => 'Ostatnie 3 miesiące';

  @override
  String get rangePastYear => 'Ostatni rok';

  @override
  String get rangePastFiveYears => 'Ostatnie 5 lat';

  @override
  String get rangePastTenYears => 'Ostatnie 10 lat';

  @override
  String get rangeShortWeek => '1 tydz.';

  @override
  String get rangeShortMonth => '1 mies.';

  @override
  String get rangeShortThreeMonths => '3 mies.';

  @override
  String get rangeShortYear => '1 rok';

  @override
  String get rangeShortFiveYears => '5 lat';

  @override
  String get rangeShortTenYears => '10 lat';

  @override
  String get settingsDarkMode => 'Tryb ciemny';

  @override
  String get settingsOn => 'Włączone';

  @override
  String get settingsOff => 'Wyłączone';

  @override
  String get settingsGeneralTitle => 'Ogólne';

  @override
  String get settingsGeneralSubtitle => 'Zachowanie aplikacji i preferencje';

  @override
  String get settingsShowCurrencyFlags => 'Pokaż flagi walut';

  @override
  String get settingsUseCurrencySymbols => 'Używaj symboli walut';

  @override
  String get settingsCurrenciesTitle => 'Waluty';

  @override
  String get settingsCurrenciesSubtitle => 'Waluta bazowa i opcje wyświetlania';

  @override
  String get settingsDefaultBase => 'Waluta bazowa';

  @override
  String get settingsDisplayCurrencies => 'Wyświetlane waluty';

  @override
  String get settingsUnableToLoadCurrencies => 'Nie udało się załadować walut';

  @override
  String get settingsAllCurrencies => 'Wszystkie waluty';

  @override
  String get settingsNoCurrenciesSelected => 'Nie wybrano walut';

  @override
  String settingsSelectedCurrenciesMore(Object visible, Object remaining) {
    return '$visible +$remaining więcej';
  }

  @override
  String get settingsVersion => 'Wersja';

  @override
  String get settingsSendFeedback => 'Wyślij opinię';

  @override
  String get settingsSendFeedbackSubtitle =>
      'Wyślij wiadomość i zrzut ekranu z adnotacjami e-mailem';

  @override
  String get settingsFeedbackShared => 'Szkic e-maila jest gotowy.';

  @override
  String get settingsFeedbackShareFailed =>
      'Nie udało się otworzyć aplikacji e-mail.';

  @override
  String get settingsLeaveReview => 'Zostaw opinię';

  @override
  String get settingsLeaveReviewSubtitle =>
      'Oceń rozszerzenie w Chrome Web Store';

  @override
  String get settingsLeaveReviewOpenFailed =>
      'Nie udało się otworzyć strony opinii.';

  @override
  String get settingsSelectAll => 'Zaznacz wszystko';

  @override
  String get settingsClear => 'Wyczyść';

  @override
  String get settingsCancel => 'Anuluj';

  @override
  String get settingsSave => 'Zapisz';

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
