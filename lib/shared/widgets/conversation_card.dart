import 'package:application/core/constants/colors.dart';
import 'package:application/features/conversation/conversation_view.dart';
import 'package:flutter/material.dart';

class ConversationCard extends StatelessWidget {
  const ConversationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConversationDemoView())),
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
            Icon(Icons.spatial_tracking_outlined, color: AppColors.white, size: 40),
            SizedBox(height: 10),
            Text(
              "Start Conversation",
              style: TextStyle(color: AppColors.white, fontSize: 20),
            ),
            Text(
              "Takes 1-2 minutes",
              style: TextStyle(color: AppColors.whiteText),
            ),
          ],
        ),
      ),
    );
  }
}
