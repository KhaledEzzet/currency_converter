import 'package:flutter/material.dart';

class PerformanceSummary extends StatelessWidget {
  const PerformanceSummary({
    super.key,
    required this.text,
    this.color = Colors.redAccent,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
        ),
      ),
    );
  }
}
