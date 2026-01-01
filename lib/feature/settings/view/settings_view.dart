import 'package:currency_converter/app/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isDarkMode = themeMode == ThemeMode.dark;
              return SwitchListTile(
                value: isDarkMode,
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                secondary: const Icon(Icons.dark_mode),
                title: const Text('Dark mode'),
                subtitle: Text(isDarkMode ? 'On' : 'Off'),
              );
            },
          ),
          const Divider(height: 24),
          const ListTile(
            leading: Icon(Icons.tune),
            title: Text('General'),
            subtitle: Text('App behavior and preferences'),
          ),
          const Divider(height: 24),
          const ListTile(
            leading: Icon(Icons.currency_exchange),
            title: Text('Currencies'),
            subtitle: Text('Default base and display options'),
          ),
        ],
      ),
    );
  }
}
