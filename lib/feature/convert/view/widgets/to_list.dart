import 'package:currency_converter/feature/convert/cubit/convert_state.dart';
import 'package:currency_converter/feature/convert/view/widgets/conversion_card.dart';
import 'package:flutter/material.dart';

class ToList extends StatelessWidget {
  const ToList({
    super.key,
    required this.state,
    required this.currencies,
  });

  final ConvertState state;
  final List<String> currencies;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: currencies.length,
      itemBuilder: (context, index) {
        final currency = currencies[index];
        return ConversionCard(
          state: state,
          currency: currency,
        );
      },
    );
  }
}
