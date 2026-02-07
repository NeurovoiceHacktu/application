import 'package:application/core/constants/colors.dart';
import 'package:flutter/material.dart';

class LatestCheckupCard extends StatelessWidget {
  final VoidCallback onTap;
  const LatestCheckupCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: AppColors.successGreen),
        title: const Text("Latest Check-up"),
        subtitle: const Text("Stable (Low Risk)"),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
