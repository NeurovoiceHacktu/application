import 'package:neurovoice_app/core/constants/colors.dart';
import 'package:flutter/material.dart';

class FaceTestCard extends StatelessWidget {
  final VoidCallback onTap;
  const FaceTestCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: AppColors.primaryFace,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.face, color: AppColors.white, size: 40),
            SizedBox(height: 10),
            Text(
              "Start Face Test",
              style: TextStyle(color: AppColors.white, fontSize: 20),
            ),
            Text(
              "Takes less than 1 minute",
              style: TextStyle(color: AppColors.whiteText),
            ),
          ],
        ),
      ),
    );
  }
}
