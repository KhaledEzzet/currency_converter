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

    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final cacheWidth = (_flagWidth * devicePixelRatio).round();
    final cacheHeight = (_flagHeight * devicePixelRatio).round();

    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: CachedNetworkImage(
        imageUrl: 'https://flagcdn.com/w20/$code.png',
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
