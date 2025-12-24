import 'package:currency_converter/feature/convert/cubit/convert_cubit.dart';
import 'package:currency_converter/feature/convert/cubit/convert_state.dart';
import 'package:currency_converter/feature/convert/view/widgets/from_row.dart';
import 'package:currency_converter/feature/convert/view/widgets/section_title.dart';
import 'package:currency_converter/feature/convert/view/widgets/to_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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
          final targetCurrencies = state.currencies
              .where((currency) => currency != state.fromCurrency)
              .toList();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: FormBuilder(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(text: 'From'),
                  const SizedBox(height: 20),
                  FromRow(
                    state: state,
                    onCurrencyChanged:
                        context.read<ConvertCubit>().updateFromCurrency,
                    onAmountChanged: (value) => context
                        .read<ConvertCubit>()
                        .updateAmount(value),
                  ),
                  const SizedBox(height: 32),
                  const SectionTitle(text: 'To'),
                  const SizedBox(height: 12),
                  ToList(
                    state: state,
                    currencies: targetCurrencies,
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
