import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AmountField extends StatelessWidget {
  const AmountField({
    required this.symbol, required this.onChanged, super.key,
  });

  final String symbol;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'from_amount',
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixText: symbol.isEmpty ? null : symbol,
      ),
      textAlign: TextAlign.end,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.numeric(),
        FormBuilderValidators.min(0),
      ]),
      onChanged: (value) => onChanged(value ?? ''),
    );
  }
}
