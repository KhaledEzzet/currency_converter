import 'package:currency_converter/feature/convert/view/widgets/currency_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ChartsCurrencyRow extends StatelessWidget {
  const ChartsCurrencyRow({
    super.key,
    required this.formKey,
    required this.currencies,
    required this.currencyFlags,
    required this.fromCurrency,
    required this.toCurrency,
    required this.onFromChanged,
    required this.onToChanged,
    required this.onSwap,
  });

  final GlobalKey<FormBuilderState> formKey;
  final List<String> currencies;
  final Map<String, String> currencyFlags;
  final String fromCurrency;
  final String toCurrency;
  final ValueChanged<String?> onFromChanged;
  final ValueChanged<String?> onToChanged;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Row(
        children: [
          Expanded(
            child: CurrencyDropdownField(
              name: 'chart_from_currency',
              currencies: currencies,
              currencyFlags: currencyFlags,
              initialValue: fromCurrency,
              onChanged: onFromChanged,
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: onSwap,
            icon: const Icon(Icons.swap_horiz_rounded),
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CurrencyDropdownField(
              name: 'chart_to_currency',
              currencies: currencies,
              currencyFlags: currencyFlags,
              initialValue: toCurrency,
              onChanged: onToChanged,
            ),
          ),
        ],
      ),
    );
  }
}
