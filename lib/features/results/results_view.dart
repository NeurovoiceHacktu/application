import 'package:application/core/constants/colors.dart';
import 'package:flutter/material.dart';

class ResultsView extends StatelessWidget {
  const ResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! Map<String, dynamic>) {
      return const _NoResultsView();
    }

    final double riskScore = (args['riskScore'] as num).toDouble();
    final String riskLevel = args['riskLevel'] as String;

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
              // const _WaveBars(),
              // const SizedBox(height: 24),
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
                "Risk Score: ${(riskScore * 100).toStringAsFixed(1)}%",
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

// TODO: Implement animated wave bars
// class _WaveBars extends StatelessWidget {
//   const _WaveBars();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 120,
//       alignment: Alignment.center,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(
//           7,
//           (index) => Container(
//             margin: const EdgeInsets.symmetric(horizontal: 4),
//             width: 10,
//             height: 60 + (index % 2) * 20,
//             decoration: BoxDecoration(
//               color: AppColors.primaryBlue.withOpacity(0.7),
//               borderRadius: BorderRadius.circular(6),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
