import 'package:currency_converter/feature/convert/cubit/convert_cubit.dart';
import 'package:currency_converter/feature/convert/cubit/convert_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ConvertView extends StatelessWidget {
  const ConvertView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Converter',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<ConvertCubit, ConvertState>(
        builder: (context, state) {
          final symbol = state.currencySymbols[state.fromCurrency] ?? '';
          final targetCurrencies = state.currencies
              .where((currency) => currency != state.fromCurrency)
              .toList();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: FormBuilder(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'From',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderDropdown<String>(
                          name: 'from_currency',
                          initialValue: state.fromCurrency,
                          decoration: const InputDecoration(
                            labelText: 'Currency',
                          ),
                          items: state.currencies
                              .map(
                                (currency) => DropdownMenuItem<String>(
                                  value: currency,
                                  child: Text(currency),
                                ),
                              )
                              .toList(),
                          validator: FormBuilderValidators.required(),
                          onChanged: context.read<ConvertCubit>().updateFromCurrency,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'from_amount',
                          decoration: InputDecoration(
                            labelText: 'Amount',
                            prefixText: symbol.isEmpty ? null : symbol,
                          ),
                          keyboardType:
                              const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.min(0),
                          ]),
                          onChanged: (value) => context
                              .read<ConvertCubit>()
                              .updateAmount(value ?? ''),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'To',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: targetCurrencies
                        .map(
                          (currency) {
                            final converted = state.convertedAmounts[currency];
                            final convertedText = converted == null
                                ? '--'
                                : converted.toStringAsFixed(2);
                            final targetSymbol =
                                state.currencySymbols[currency] ?? '';
                            final displayValue = targetSymbol.isEmpty
                                ? convertedText
                                : '$targetSymbol $convertedText';
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(currency),
                                  Text(
                                    displayValue,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
