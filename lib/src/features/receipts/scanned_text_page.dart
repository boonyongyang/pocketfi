import 'package:flutter/material.dart';

class ScannedTextPage extends StatelessWidget {
  const ScannedTextPage({
    super.key,
    required this.scannedText,
  });

  final String scannedText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Scanned Text"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(scannedText),
            ],
          ),
        ),
      ),
    );
  }
}
