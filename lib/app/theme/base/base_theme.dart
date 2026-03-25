import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class BaseTheme {
  static const _fontFamilyFallback = <String>[
    'NotoNaskhArabic',
    'NotoSansDevanagari',
  ];
  static const _webFontFamily = 'Roboto';

  Brightness get brightness;
  ColorScheme get colorScheme;

  ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      // Chrome extensions cannot rely on Flutter web downloading fallback
      // Noto fonts at runtime, so bundle the primary web text font locally.
      fontFamily: kIsWeb ? _webFontFamily : null,
      fontFamilyFallback: _fontFamilyFallback,
      typography: Typography.material2021(),
    );
  }
}
