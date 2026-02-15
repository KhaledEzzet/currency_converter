import 'package:currency_converter/feature/convert/cubit/convert_state.dart';
import 'package:currency_converter/feature/convert/view/widgets/conversion_card.dart';
import 'package:flutter/material.dart';

class ToList extends StatelessWidget {
  const ToList({
    required this.state, required this.currencies, required this.showCurrencyFlags, required this.useCurrencySymbols, super.key,
  });

  final ConvertState state;
  final List<String> currencies;
  final bool showCurrencyFlags;
  final bool useCurrencySymbols;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: currencies.length,
      itemBuilder: (context, index) {
        final currency = currencies[index];
        return ConversionCard(
          state: state,
          currency: currency,
          showCurrencyFlags: showCurrencyFlags,
          useCurrencySymbols: useCurrencySymbols,
        );
      },
    );
  }
}
