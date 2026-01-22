import 'package:currency_converter/feature/convert/view/widgets/currency_flag.dart';
import 'package:flutter/material.dart';

class RateHeader extends StatelessWidget {
  const RateHeader({
    super.key,
    required this.fromCurrency,
    required this.toCurrency,
    required this.rateText,
    this.dotColor = Colors.redAccent,
    this.fromFlagCode,
    this.toFlagCode,
    this.showFlags = true,
  });

  final String fromCurrency;
  final String toCurrency;
  final String rateText;
  final Color dotColor;
  final String? fromFlagCode;
  final String? toFlagCode;
  final bool showFlags;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showFlags) ...[
            CurrencyFlag(code: fromFlagCode),
            const SizedBox(width: 6),
          ],
          Text(
            '1 $fromCurrency = $rateText',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (showFlags) ...[
            const SizedBox(width: 6),
            CurrencyFlag(code: toFlagCode),
          ],
          const SizedBox(width: 6),
          Text(
            toCurrency,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
