import 'package:currency_converter/feature/convert/view/widgets/currency_flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CurrencyDropdownField extends StatelessWidget {
  const CurrencyDropdownField({
    required this.name, required this.currencies, required this.currencyFlags, required this.onChanged, super.key,
    this.initialValue,
    this.showFlags = true,
  });

  final String name;
  final List<String> currencies;
  final Map<String, String> currencyFlags;
  final ValueChanged<String?> onChanged;
  final String? initialValue;
  final bool showFlags;

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown<String>(
      name: name,
      initialValue: initialValue,
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
      items: currencies
          .map(
            (currency) => DropdownMenuItem<String>(
              value: currency,
              child: Row(
                children: [
                  if (showFlags) ...[
                    CurrencyFlag(code: currencyFlags[currency]),
                    const SizedBox(width: 8),
                  ],
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
