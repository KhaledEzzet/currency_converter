// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get flutter => 'Flutter';

  @override
  String get tabConvert => 'Convertir';

  @override
  String get tabCharts => 'Graphiques';

  @override
  String get tabSettings => 'Paramètres';

  @override
  String get titleConverter => 'Convertisseur';

  @override
  String get titleCharts => 'Graphiques';

  @override
  String get titleSettings => 'Paramètres';

  @override
  String get labelFrom => 'De';

  @override
  String get labelTo => 'À';

  @override
  String get labelLanguage => 'Langue';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageArabic => 'Arabe';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageRussian => 'Russe';

  @override
  String get languageGerman => 'Allemand';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get languagePolish => 'Polonais';

  @override
  String get errorGeneric => 'Une erreur s\'est produite.';

  @override
  String get rangePastWeek => 'Semaine dernière';

  @override
  String get rangePastMonth => 'Mois dernier';

  @override
  String get rangePastThreeMonths => '3 derniers mois';

  @override
  String get rangePastYear => 'Année dernière';

  @override
  String get rangePastFiveYears => '5 dernières années';

  @override
  String get rangePastTenYears => '10 dernières années';

  @override
  String get rangeShortWeek => '1 sem.';

  @override
  String get rangeShortMonth => '1 mois';

  @override
  String get rangeShortThreeMonths => '3 mois';

  @override
  String get rangeShortYear => '1 an';

  @override
  String get rangeShortFiveYears => '5 ans';

  @override
  String get rangeShortTenYears => '10 ans';

  @override
  String get settingsDarkMode => 'Mode sombre';

  @override
  String get settingsOn => 'Activé';

  @override
  String get settingsOff => 'Désactivé';

  @override
  String get settingsGeneralTitle => 'Général';

  @override
  String get settingsGeneralSubtitle =>
      'Comportement et préférences de l\'application';

  @override
  String get settingsShowCurrencyFlags => 'Afficher les drapeaux des devises';

  @override
  String get settingsUseCurrencySymbols => 'Utiliser les symboles monétaires';

  @override
  String get settingsCurrenciesTitle => 'Devises';

  @override
  String get settingsCurrenciesSubtitle =>
      'Devise de base et options d\'affichage';

  @override
  String get settingsDefaultBase => 'Devise de base';

  @override
  String get settingsDisplayCurrencies => 'Devises affichées';

  @override
  String get settingsUnableToLoadCurrencies =>
      'Impossible de charger les devises';

  @override
  String get settingsAllCurrencies => 'Toutes les devises';

  @override
  String get settingsNoCurrenciesSelected => 'Aucune devise sélectionnée';

  @override
  String settingsSelectedCurrenciesMore(Object visible, Object remaining) {
    return '$visible +$remaining de plus';
  }

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsSendFeedback => 'Envoyer un retour';

  @override
  String get settingsSendFeedbackSubtitle =>
      'Envoyez un message et une capture d\'écran annotée par e-mail';

  @override
  String get settingsFeedbackShared => 'Votre brouillon d\'e-mail est prêt.';

  @override
  String get settingsFeedbackShareFailed =>
      'Impossible d\'ouvrir votre application e-mail.';

  @override
  String get settingsLeaveReview => 'Laisser un avis';

  @override
  String get settingsLeaveReviewSubtitle =>
      'Évaluez l\'extension sur le Chrome Web Store';

  @override
  String get settingsLeaveReviewOpenFailed =>
      'Impossible d\'ouvrir la page d\'avis.';

  @override
  String get settingsSelectAll => 'Tout sélectionner';

  @override
  String get settingsClear => 'Effacer';

  @override
  String get settingsCancel => 'Annuler';

  @override
  String get settingsSave => 'Enregistrer';

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
