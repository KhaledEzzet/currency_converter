import 'package:flutter/material.dart';

abstract class BaseTheme {
  static const _fontFamilyFallback = <String>[
    'NotoNaskhArabic',
    'NotoSansDevanagari',
  ];

  Brightness get brightness;
  ColorScheme get colorScheme;

  ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamilyFallback: _fontFamilyFallback,
      typography: Typography.material2021(),
    );
  }
}
