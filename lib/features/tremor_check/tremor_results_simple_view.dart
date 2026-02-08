import 'package:application/core/constants/colors.dart';
import 'package:flutter/material.dart';

class TremorResultsSimpleView extends StatelessWidget {
  const TremorResultsSimpleView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! Map<String, dynamic>) {
      return const _NoResultsView();
    }

    final String riskLevel = args['riskLevel'] as String;
    final double confidence = (args['confidence'] as num).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Results"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                riskLevel == "High"
                    ? Icons.warning
                    : riskLevel == "Medium"
                    ? Icons.info_outline
                    : Icons.check_circle,
                size: 80,
                color: riskLevel == "High"
                    ? AppColors.red
                    : riskLevel == "Medium"
                    ? AppColors.orange
                    : AppColors.green,
              ),
              const SizedBox(height: 16),
              Text(
                "Risk Level: $riskLevel",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Confidence: ${confidence.toStringAsFixed(1)}%",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoResultsView extends StatelessWidget {
  const _NoResultsView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "No results available",
          style: TextStyle(color: AppColors.gray),
        ),
      ),
    );
  }
}
