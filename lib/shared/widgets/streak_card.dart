import 'package:application/core/constants/colors.dart';
import 'package:application/features/home/home_viewmodel.dart';
import 'package:flutter/material.dart';

class StreakCard extends StatelessWidget {
  final HomeViewModel viewModel;
  const StreakCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("DAILY STREAK"),
                Text(
                  "${viewModel.streakDays} Days",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("Consistency is key to health."),
              ],
            ),
            CircularProgressIndicator(
              value: viewModel.streakPercent / 100,
              color: AppColors.dangerRed,
            ),
          ],
        ),
      ),
    );
  }
}
