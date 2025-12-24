import 'package:flutter/material.dart';

class RangeSelector extends StatelessWidget {
  const RangeSelector({
    super.key,
    required this.ranges,
    required this.selectedRange,
    required this.onSelected,
  });

  final List<String> ranges;
  final String selectedRange;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        children: [
          for (final range in ranges)
            ChoiceChip(
              label: Text(range),
              selected: selectedRange == range,
              onSelected: (_) => onSelected(range),
              selectedColor: const Color(0xFF3B5B87),
              labelStyle: TextStyle(
                color: selectedRange == range
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: const BorderSide(
                color: Color(0xFF3B5B87),
              ),
            ),
        ],
      ),
    );
  }
}
