// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get flutter => 'Flutter';

  @override
  String get tabConvert => 'Конвертация';

  @override
  String get tabCharts => 'Графики';

  @override
  String get tabSettings => 'Настройки';

  @override
  String get titleConverter => 'Конвертер';

  @override
  String get titleCharts => 'Графики';

  @override
  String get titleSettings => 'Настройки';

  @override
  String get labelFrom => 'Из';

  @override
  String get labelTo => 'В';

  @override
  String get labelLanguage => 'Язык';

  @override
  String get languageEnglish => 'Английский';

  @override
  String get languageArabic => 'Арабский';

  @override
  String get languageFrench => 'Французский';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageGerman => 'Немецкий';

  @override
  String get languageHindi => 'Хинди';

  @override
  String get languagePolish => 'Польский';

  @override
  String get errorGeneric => 'Что-то пошло не так.';

  @override
  String get rangePastWeek => 'Прошлая неделя';

  @override
  String get rangePastMonth => 'Прошлый месяц';

  @override
  String get rangePastThreeMonths => 'Последние 3 месяца';

  @override
  String get rangePastYear => 'Прошлый год';

  @override
  String get rangePastFiveYears => 'Последние 5 лет';

  @override
  String get rangePastTenYears => 'Последние 10 лет';

  @override
  String get settingsDarkMode => 'Темный режим';

  @override
  String get settingsOn => 'Вкл.';

  @override
  String get settingsOff => 'Выкл.';

  @override
  String get settingsGeneralTitle => 'Общие';

  @override
  String get settingsGeneralSubtitle => 'Поведение приложения и настройки';

  @override
  String get settingsShowCurrencyFlags => 'Показывать флаги валют';

  @override
  String get settingsUseCurrencySymbols => 'Использовать символы валют';

  @override
  String get settingsCurrenciesTitle => 'Валюты';

  @override
  String get settingsCurrenciesSubtitle =>
      'Базовая валюта и параметры отображения';

  @override
  String get settingsDefaultBase => 'Базовая валюта';

  @override
  String get settingsDisplayCurrencies => 'Отображаемые валюты';

  @override
  String get settingsUnableToLoadCurrencies => 'Не удалось загрузить валюты';

  @override
  String get settingsAllCurrencies => 'Все валюты';

  @override
  String get settingsNoCurrenciesSelected => 'Валюты не выбраны';

  @override
  String settingsSelectedCurrenciesMore(Object visible, Object remaining) {
    return '$visible +$remaining еще';
  }

  @override
  String get settingsVersion => 'Версия';

  @override
  String get settingsSelectAll => 'Выбрать все';

  @override
  String get settingsClear => 'Очистить';

  @override
  String get settingsCancel => 'Отмена';

  @override
  String get settingsSave => 'Сохранить';
}
