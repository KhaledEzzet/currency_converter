import 'package:currency_converter/feature/convert/view/widgets/currency_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ChartsCurrencyRow extends StatelessWidget {
  const ChartsCurrencyRow({
    required this.formKey,
    required this.currencies,
    required this.currencyFlags,
    required this.fromCurrency,
    required this.toCurrency,
    required this.onFromChanged,
    required this.onToChanged,
    required this.onSwap,
    required this.showCurrencyFlags,
    super.key,
    this.fromCurrencyWrapper,
    this.swapButtonWrapper,
    this.toCurrencyWrapper,
  });

  final GlobalKey<FormBuilderState> formKey;
  final List<String> currencies;
  final Map<String, String> currencyFlags;
  final String fromCurrency;
  final String toCurrency;
  final ValueChanged<String?> onFromChanged;
  final ValueChanged<String?> onToChanged;
  final VoidCallback onSwap;
  final bool showCurrencyFlags;
  final Widget Function(Widget child)? fromCurrencyWrapper;
  final Widget Function(Widget child)? swapButtonWrapper;
  final Widget Function(Widget child)? toCurrencyWrapper;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Row(
        children: [
          Expanded(
            child: (fromCurrencyWrapper ?? _identity)(
              CurrencyDropdownField(
                name: 'chart_from_currency',
                currencies: currencies,
                currencyFlags: currencyFlags,
                showFlags: showCurrencyFlags,
                initialValue: fromCurrency,
                onChanged: onFromChanged,
              ),
            ),
          ),
          const SizedBox(width: 12),
          (swapButtonWrapper ?? _identity)(
            IconButton(
              onPressed: onSwap,
              icon: const Icon(Icons.swap_horiz_rounded),
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(),
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: (toCurrencyWrapper ?? _identity)(
              CurrencyDropdownField(
                name: 'chart_to_currency',
                currencies: currencies,
                currencyFlags: currencyFlags,
                showFlags: showCurrencyFlags,
                initialValue: toCurrency,
                onChanged: onToChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _identity(Widget child) => child;
