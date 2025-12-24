import 'package:currency_converter/feature/convert/cubit/convert_state.dart';
import 'package:currency_converter/feature/convert/view/widgets/currency_flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CurrencyDropdownField extends StatelessWidget {
  const CurrencyDropdownField({
    super.key,
    required this.state,
    required this.onChanged,
  });

  final ConvertState state;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown<String>(
      name: 'from_currency',
      initialValue: state.fromCurrency,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      padding: const EdgeInsets.only(right: 4),
      items: state.currencies
          .map(
            (currency) => DropdownMenuItem<String>(
              value: currency,
              child: Row(
                children: [
                  CurrencyFlag(code: state.currencyFlags[currency]),
                  const SizedBox(width: 8),
                  Text(currency),
                ],
              ),
            ),
          )
          .toList(),
      validator: FormBuilderValidators.required(),
      onChanged: onChanged,
    );
  }
}
