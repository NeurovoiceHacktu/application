import 'package:application/core/constants/colors.dart';
import 'package:application/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'tremor_check_viewmodel.dart';

class TremorCheckView extends StatelessWidget {
  const TremorCheckView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryTremor,
        title: const Text('Tremor Detection'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<TremorCheckViewModel>(
        builder: (context, viewModel, _) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _buildInstructionCard(),
                  const Spacer(),
                  _buildTremorAnimation(viewModel),
                  const SizedBox(height: 40),
                  if (viewModel.isRecording)
                    _buildCountdown(viewModel)
                  else
                    _buildStartButton(context, viewModel),
                  const Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(blurRadius: 20, color: AppColors.lightBlack)],
      ),
      child: Column(
        children: const [
          Text("Level 3", style: AppTextStyles.stepText),
          SizedBox(height: 10),
          Text('Hold Your Phone Steady', style: AppTextStyles.title),
          SizedBox(height: 8),
          Text(
            "Hold your phone steadily in your hand for 10 seconds while we measure tremor patterns.",
            textAlign: TextAlign.center,
            style: AppTextStyles.subtitle,
          ),
        ],
      ),
    );
  }

  Widget _buildTremorAnimation(TremorCheckViewModel viewModel) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: viewModel.isRecording 
            ? AppColors.primaryTremor.withOpacity(0.2)
            : AppColors.lightGrey,
      ),
      child: Center(
        child: Icon(
          Icons.vibration,
          size: 80,
          color: viewModel.isRecording 
              ? AppColors.primaryTremor
              : AppColors.grey,
        ),
      ),
    );
  }

  Widget _buildCountdown(TremorCheckViewModel viewModel) {
    return Column(
      children: [
        Text(
          '${viewModel.countdown}',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTremor,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Hold steady...',
          style: AppTextStyles.subtitle,
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context, TremorCheckViewModel viewModel) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            viewModel.startTremorTest();
            // Navigate to processing screen after recording completes
            Future.delayed(const Duration(seconds: 11), () {
              if (context.mounted) {
                Navigator.pushReplacementNamed(
                  context,
                  '/tremor_processing',
                );
              }
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryTremor,
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Start Test',
            style: TextStyle(fontSize: 18, color: AppColors.white),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Make sure you are in a comfortable position',
          style: AppTextStyles.subtitleSmall,
        ),
      ],
    );
  }
}
