import 'package:flutter/material.dart';

const double _flagWidth = 24;
const double _flagHeight = 16;

class CurrencyFlag extends StatelessWidget {
  const CurrencyFlag({super.key, required this.code});

  final String? code;

  @override
  Widget build(BuildContext context) {
    if (code == null || code!.isEmpty) {
      return const SizedBox(width: _flagWidth, height: _flagHeight);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Image.network(
        'https://flagcdn.com/w20/$code.png',
        width: _flagWidth,
        height: _flagHeight,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const SizedBox(width: _flagWidth, height: _flagHeight);
        },
      ),
    );
  }
}
