import 'package:application/core/constants/colors.dart';
import 'package:flutter/material.dart';

class DidYouKnowCard extends StatelessWidget {
  final String fact;
  const DidYouKnowCard({super.key, required this.fact});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Did you know?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            fact,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.gray,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
