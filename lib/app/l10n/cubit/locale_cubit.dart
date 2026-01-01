import 'package:currency_converter/app/l10n/arb/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class LocaleCubit extends HydratedCubit<Locale> {
  LocaleCubit({required Locale initialLocale})
      : super(_normalizeLocale(initialLocale));

  static Locale _normalizeLocale(Locale locale) => Locale(locale.languageCode);

  static bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  void updateLocale(Locale locale) {
    final normalized = _normalizeLocale(locale);
    if (!isSupported(normalized) || normalized == state) {
      return;
    }
    emit(normalized);
  }

  @override
  Locale? fromJson(Map<String, dynamic> json) {
    final languageCode = json['languageCode'] as String?;
    if (languageCode == null) {
      return null;
    }

    final locale = Locale(languageCode);
    return isSupported(locale) ? locale : null;
  }

  @override
  Map<String, dynamic> toJson(Locale state) => {
        'languageCode': state.languageCode,
      };
}
