import 'package:flutter/material.dart';

class RateHeader extends StatelessWidget {
  const RateHeader({
    super.key,
    required this.fromCurrency,
    required this.toCurrency,
    required this.rateText,
    this.dotColor = Colors.redAccent,
  });

  final String fromCurrency;
  final String toCurrency;
  final String rateText;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '1 $fromCurrency = $rateText $toCurrency',
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
