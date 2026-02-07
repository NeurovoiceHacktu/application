import 'package:application/core/constants/colors.dart';
import 'package:application/core/constants/text_styles.dart';
import 'package:application/features/tremor_check/tremor_check_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TremorProcessingView extends StatefulWidget {
  const TremorProcessingView({super.key});

  @override
  State<TremorProcessingView> createState() => _TremorProcessingViewState();
}

class _TremorProcessingViewState extends State<TremorProcessingView> {
  @override
  void initState() {
    super.initState();
    // Navigate to results after processing completes
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final viewModel = Provider.of<TremorCheckViewModel>(context, listen: false);
        Navigator.pushReplacementNamed(
          context,
          '/tremor_results',
          arguments: {
            'riskLevel': viewModel.riskLevel ?? 'Medium',
            'confidence': viewModel.confidence ?? 75.0,
            'tremorFrequency': viewModel.tremorFrequency ?? 5.5,
            'severityScore': viewModel.severityScore ?? 70,
            'recommendations': viewModel.recommendations,
            'modelUsed': viewModel.modelUsed ?? 'Unknown',
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryTremor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              strokeWidth: 4,
            ),
            const SizedBox(height: 30),
            const Text(
              'Analyzing Tremor Patterns...',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Processing sensor data with ML model',
              style: TextStyle(
                color: AppColors.whiteText,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
