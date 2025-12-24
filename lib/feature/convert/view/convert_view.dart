import 'package:flutter/material.dart';

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
      body: const Center(
        child: Text('Convert'),
      ),
    );
  }
}
