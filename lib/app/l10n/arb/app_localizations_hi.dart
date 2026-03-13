// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get flutter => 'Flutter';

  @override
  String get tabConvert => 'रूपांतरण';

  @override
  String get tabCharts => 'चार्ट';

  @override
  String get tabSettings => 'सेटिंग्स';

  @override
  String get titleConverter => 'मुद्रा परिवर्तक';

  @override
  String get titleCharts => 'चार्ट';

  @override
  String get titleSettings => 'सेटिंग्स';

  @override
  String get labelFrom => 'से';

  @override
  String get labelTo => 'तक';

  @override
  String get labelLanguage => 'भाषा';

  @override
  String get languageEnglish => 'अंग्रेज़ी';

  @override
  String get languageArabic => 'अरबी';

  @override
  String get languageFrench => 'फ़्रेंच';

  @override
  String get languageRussian => 'रूसी';

  @override
  String get languageGerman => 'जर्मन';

  @override
  String get languageHindi => 'हिंदी';

  @override
  String get languagePolish => 'पोलिश';

  @override
  String get errorGeneric => 'कुछ गलत हो गया.';

  @override
  String get rangePastWeek => 'पिछला सप्ताह';

  @override
  String get rangePastMonth => 'पिछला महीना';

  @override
  String get rangePastThreeMonths => 'पिछले 3 महीने';

  @override
  String get rangePastYear => 'पिछला साल';

  @override
  String get rangePastFiveYears => 'पिछले 5 साल';

  @override
  String get rangePastTenYears => 'पिछले 10 साल';

  @override
  String get rangeShortWeek => '1 सप्ताह';

  @override
  String get rangeShortMonth => '1 महीना';

  @override
  String get rangeShortThreeMonths => '3 महीने';

  @override
  String get rangeShortYear => '1 साल';

  @override
  String get rangeShortFiveYears => '5 साल';

  @override
  String get rangeShortTenYears => '10 साल';

  @override
  String get settingsDarkMode => 'डार्क मोड';

  @override
  String get settingsOn => 'चालू';

  @override
  String get settingsOff => 'बंद';

  @override
  String get settingsGeneralTitle => 'सामान्य';

  @override
  String get settingsGeneralSubtitle => 'ऐप व्यवहार और प्राथमिकताएं';

  @override
  String get settingsShowCurrencyFlags => 'मुद्रा झंडे दिखाएं';

  @override
  String get settingsUseCurrencySymbols => 'मुद्रा चिह्न उपयोग करें';

  @override
  String get settingsCurrenciesTitle => 'मुद्राएँ';

  @override
  String get settingsCurrenciesSubtitle => 'डिफ़ॉल्ट आधार और प्रदर्शन विकल्प';

  @override
  String get settingsDefaultBase => 'डिफ़ॉल्ट आधार मुद्रा';

  @override
  String get settingsDisplayCurrencies => 'दिखाई जाने वाली मुद्राएँ';

  @override
  String get settingsUnableToLoadCurrencies => 'मुद्राएँ लोड नहीं हो सकीं';

  @override
  String get settingsAllCurrencies => 'सभी मुद्राएँ';

  @override
  String get settingsNoCurrenciesSelected => 'कोई मुद्रा चयनित नहीं है';

  @override
  String settingsSelectedCurrenciesMore(Object visible, Object remaining) {
    return '$visible +$remaining और';
  }

  @override
  String get settingsVersion => 'संस्करण';

  @override
  String get settingsSendFeedback => 'फ़ीडबैक भेजें';

  @override
  String get settingsSendFeedbackSubtitle =>
      'ईमेल से नोट और टिप्पणी वाला स्क्रीनशॉट भेजें';

  @override
  String get settingsFeedbackShared => 'आपका ईमेल ड्राफ्ट तैयार है.';

  @override
  String get settingsFeedbackShareFailed => 'आपका ईमेल ऐप खोला नहीं जा सका.';

  @override
  String get settingsSelectAll => 'सभी चुनें';

  @override
  String get settingsClear => 'साफ़ करें';

  @override
  String get settingsCancel => 'रद्द करें';

  @override
  String get settingsSave => 'सहेजें';

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
