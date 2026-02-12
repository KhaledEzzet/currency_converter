import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const double _flagWidth = 24;
const double _flagHeight = 16;

class CurrencyFlag extends StatelessWidget {
  const CurrencyFlag({required this.code, super.key});

  final String? code;

  @override
  Widget build(BuildContext context) {
    if (code == null || code!.isEmpty) {
      return const _FlagPlaceholder();
    }
    final normalizedCode = code!.toLowerCase();
    if (normalizedCode == 'eu') {
      return const _EuroFlag();
    }

    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final cacheWidth = (_flagWidth * devicePixelRatio).round();
    final cacheHeight = (_flagHeight * devicePixelRatio).round();

    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: CachedNetworkImage(
        imageUrl: 'https://flagcdn.com/w20/$normalizedCode.png',
        width: _flagWidth,
        height: _flagHeight,
        fit: BoxFit.cover,
        memCacheWidth: cacheWidth,
        memCacheHeight: cacheHeight,
        filterQuality: FilterQuality.high,
        placeholder: (_, __) => const _FlagPlaceholder(),
        errorWidget: (_, __, ___) => const _FlagPlaceholder(),
      ),
    );
  }
}

class _EuroFlag extends StatelessWidget {
  const _EuroFlag();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: CustomPaint(
        size: const Size(_flagWidth, _flagHeight),
        painter: const _EuroFlagPainter(),
      ),
    );
  }
}

class _EuroFlagPainter extends CustomPainter {
  const _EuroFlagPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF003399),
    );

    final starPaint = Paint()
      ..color = const Color(0xFFFFCC00)
      ..isAntiAlias = true;
    final center = Offset(size.width / 2, size.height / 2);
    final orbitRadius = size.height * 0.32;
    final starRadius = size.height * 0.08;

    for (var i = 0; i < 12; i++) {
      final angle = (-math.pi / 2) + ((2 * math.pi * i) / 12);
      final starCenter = Offset(
        center.dx + orbitRadius * math.cos(angle),
        center.dy + orbitRadius * math.sin(angle),
      );
      canvas.drawCircle(starCenter, starRadius, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FlagPlaceholder extends StatelessWidget {
  const _FlagPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _flagWidth,
      height: _flagHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
