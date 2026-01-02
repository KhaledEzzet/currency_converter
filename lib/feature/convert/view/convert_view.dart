import 'package:currency_converter/app/l10n/l10n.dart';
import 'package:currency_converter/feature/convert/cubit/convert_cubit.dart';
import 'package:currency_converter/feature/convert/cubit/convert_state.dart';
import 'package:currency_converter/feature/convert/view/widgets/from_row.dart';
import 'package:currency_converter/feature/convert/view/widgets/section_title.dart';
import 'package:currency_converter/feature/convert/view/widgets/to_list.dart';
import 'package:currency_converter/feature/settings/cubit/settings_cubit.dart';
import 'package:currency_converter/feature/settings/cubit/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

class ConvertView extends StatelessWidget {
  const ConvertView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.titleConverter,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: BlocListener<SettingsCubit, SettingsState>(
        listenWhen: (previous, current) =>
            previous.baseCurrency != current.baseCurrency ||
            previous.baseSelectionInitialized !=
                current.baseSelectionInitialized,
        listener: (context, settingsState) {
          if (!settingsState.baseSelectionInitialized) {
            return;
          }
          if (settingsState.baseCurrency !=
              context.read<ConvertCubit>().state.fromCurrency) {
            context
                .read<ConvertCubit>()
                .updateFromCurrency(settingsState.baseCurrency);
          }
        },
        child: BlocBuilder<ConvertCubit, ConvertState>(
          builder: (context, state) {
            if (state.status == ConvertStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.status == ConvertStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage ?? l10n.errorGeneric,
                ),
              );
            }

            final settingsState = context.watch<SettingsCubit>().state;
            final displayCurrencies = settingsState.displaySelectionInitialized
                ? () {
                    final selected =
                        settingsState.displayCurrencies.toSet();
                    return state.currencies
                        .where(selected.contains)
                        .toList();
                  }()
                : state.currencies;
            final targetCurrencies = displayCurrencies
                .where((currency) => currency != state.fromCurrency)
                .toList();

            return Padding(
              padding: const EdgeInsets.all(16),
              child: FormBuilder(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(text: l10n.labelFrom),
                    const SizedBox(height: 20),
                    FromRow(
                      state: state,
                      onCurrencyChanged: (currency) {
                        if (currency == null) {
                          return;
                        }
                        context
                            .read<SettingsCubit>()
                            .updateBaseCurrency(currency);
                      },
                      onAmountChanged: (value) => context
                          .read<ConvertCubit>()
                          .updateAmount(value),
                    ),
                    const SizedBox(height: 32),
                    SectionTitle(text: l10n.labelTo),
                    const SizedBox(height: 12),
                    Expanded(
                      child: targetCurrencies.isEmpty
                          ? const Center(
                              child: Text(
                                'No display currencies selected.',
                              ),
                            )
                          : ToList(
                              state: state,
                              currencies: targetCurrencies,
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
