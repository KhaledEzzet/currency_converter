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
  String get settingsSelectAll => 'تحديد الكل';

  @override
  String get settingsClear => 'مسح';

  @override
  String get settingsCancel => 'إلغاء';

  @override
  String get settingsSave => 'حفظ';
}
