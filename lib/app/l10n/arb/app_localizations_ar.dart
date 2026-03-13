// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get flutter => 'Flutter';

  @override
  String get tabConvert => 'تحويل';

  @override
  String get tabCharts => 'الرسوم البيانية';

  @override
  String get tabSettings => 'الإعدادات';

  @override
  String get titleConverter => 'محول العملات';

  @override
  String get titleCharts => 'الرسوم البيانية';

  @override
  String get titleSettings => 'الإعدادات';

  @override
  String get labelFrom => 'من';

  @override
  String get labelTo => 'إلى';

  @override
  String get labelLanguage => 'اللغة';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageFrench => 'الفرنسية';

  @override
  String get languageRussian => 'الروسية';

  @override
  String get languageGerman => 'الألمانية';

  @override
  String get languageHindi => 'الهندية';

  @override
  String get languagePolish => 'البولندية';

  @override
  String get errorGeneric => 'حدث خطأ ما.';

  @override
  String get rangePastWeek => 'الأسبوع الماضي';

  @override
  String get rangePastMonth => 'الشهر الماضي';

  @override
  String get rangePastThreeMonths => 'آخر 3 أشهر';

  @override
  String get rangePastYear => 'العام الماضي';

  @override
  String get rangePastFiveYears => 'آخر 5 سنوات';

  @override
  String get rangePastTenYears => 'آخر 10 سنوات';

  @override
  String get rangeShortWeek => '1 أسبوع';

  @override
  String get rangeShortMonth => '1 شهر';

  @override
  String get rangeShortThreeMonths => '3 أشهر';

  @override
  String get rangeShortYear => '1 سنة';

  @override
  String get rangeShortFiveYears => '5 سنوات';

  @override
  String get rangeShortTenYears => '10 سنوات';

  @override
  String get settingsDarkMode => 'الوضع الداكن';

  @override
  String get settingsOn => 'تشغيل';

  @override
  String get settingsOff => 'إيقاف';

  @override
  String get settingsGeneralTitle => 'عام';

  @override
  String get settingsGeneralSubtitle => 'سلوك التطبيق والتفضيلات';

  @override
  String get settingsShowCurrencyFlags => 'إظهار أعلام العملات';

  @override
  String get settingsUseCurrencySymbols => 'استخدام رموز العملات';

  @override
  String get settingsCurrenciesTitle => 'العملات';

  @override
  String get settingsCurrenciesSubtitle => 'العملة الأساسية وخيارات العرض';

  @override
  String get settingsDefaultBase => 'العملة الأساسية';

  @override
  String get settingsDisplayCurrencies => 'عرض العملات';

  @override
  String get settingsUnableToLoadCurrencies => 'تعذر تحميل العملات';

  @override
  String get settingsAllCurrencies => 'جميع العملات';

  @override
  String get settingsNoCurrenciesSelected => 'لم يتم تحديد عملات';

  @override
  String settingsSelectedCurrenciesMore(Object visible, Object remaining) {
    return '$visible +$remaining أخرى';
  }

  @override
  String get settingsVersion => 'الإصدار';

  @override
  String get settingsSendFeedback => 'إرسال الملاحظات';

  @override
  String get settingsSendFeedbackSubtitle =>
      'أرسل ملاحظة ولقطة شاشة مع تعليقات توضيحية عبر البريد الإلكتروني';

  @override
  String get settingsFeedbackShared => 'تم تجهيز مسودة البريد الإلكتروني.';

  @override
  String get settingsFeedbackShareFailed => 'تعذر فتح تطبيق البريد الإلكتروني.';

  @override
  String get settingsLeaveReview => 'اترك تقييمًا';

  @override
  String get settingsLeaveReviewSubtitle => 'قيّم الإضافة على Chrome Web Store';

  @override
  String get settingsLeaveReviewOpenFailed => 'تعذر فتح صفحة التقييم.';

  @override
  String get settingsSelectAll => 'تحديد الكل';

  @override
  String get settingsClear => 'مسح';

  @override
  String get settingsCancel => 'إلغاء';

  @override
  String get settingsSave => 'حفظ';

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
