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
    return Column(
      children: currencies
          .map(
            (currency) => ConversionCard(
              state: state,
              currency: currency,
            ),
          )
          .toList(),
    );
  }
}
