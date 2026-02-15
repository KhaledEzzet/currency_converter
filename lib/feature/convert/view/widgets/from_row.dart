import 'package:currency_converter/feature/convert/cubit/convert_state.dart';
import 'package:currency_converter/feature/convert/view/widgets/amount_field.dart';
import 'package:currency_converter/feature/convert/view/widgets/currency_dropdown_field.dart';
import 'package:flutter/material.dart';

class FromRow extends StatelessWidget {
  const FromRow({
    required this.state, required this.onCurrencyChanged, required this.onAmountChanged, required this.showCurrencyFlags, required this.useCurrencySymbols, super.key,
  });

  final ConvertState state;
  final ValueChanged<String?> onCurrencyChanged;
  final ValueChanged<String> onAmountChanged;
  final bool showCurrencyFlags;
  final bool useCurrencySymbols;

  @override
  Widget build(BuildContext context) {
    final symbol = useCurrencySymbols
        ? (state.currencySymbols[state.fromCurrency] ?? state.fromCurrency)
        : state.fromCurrency;

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: CurrencyDropdownField(
            name: 'from_currency',
            currencies: state.currencies,
            currencyFlags: state.currencyFlags,
            showFlags: showCurrencyFlags,
            initialValue: state.fromCurrency,
            onChanged: onCurrencyChanged,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 7,
          child: AmountField(
            symbol: symbol,
            onChanged: onAmountChanged,
          ),
        ),
      ],
    );
  }
}
