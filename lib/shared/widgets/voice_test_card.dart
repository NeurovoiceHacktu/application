import 'package:neurovoice_app/core/constants/colors.dart';
import 'package:flutter/material.dart';

class VoiceTestCard extends StatelessWidget {
  final VoidCallback onTap;
  const VoiceTestCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: AppColors.primaryVoice,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.mic, color: AppColors.white, size: 40),
            SizedBox(height: 10),
            Text(
              "Start Voice Test",
              style: TextStyle(color: AppColors.white, fontSize: 20),
            ),
            Text(
              "Takes less than 30 seconds",
              style: TextStyle(color: AppColors.whiteText),
            ),
          ],
        ),
      ),
    );
  }
}
