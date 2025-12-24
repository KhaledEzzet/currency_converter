import 'package:flutter/material.dart';
import 'package:currency_converter/app/l10n/l10n.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.flutter,
        ),
      ),
    );
  }
}
