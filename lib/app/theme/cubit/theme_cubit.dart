import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void toggleTheme() {
    emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  @override
  ThemeMode fromJson(Map<String, dynamic> json) {
    final themeMode = json['themeMode'] as String?;
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == themeMode,
      orElse: () => ThemeMode.light,
    );
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {'themeMode': state.name};
  }
}
