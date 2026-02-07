import 'package:neurovoice_app/core/constants/strings.dart';
import 'package:neurovoice_app/core/constants/text_styles.dart';
import 'package:neurovoice_app/shared/widgets/daily_tip_card.dart';
import 'package:neurovoice_app/shared/widgets/face_test_card.dart';
import 'package:neurovoice_app/shared/widgets/streak_card.dart';
import 'package:neurovoice_app/shared/widgets/tremor_test_card.dart';
import 'package:neurovoice_app/shared/widgets/voice_test_card.dart';
import 'package:flutter/material.dart';
import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeViewModel viewModel = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "Good morning,\n${viewModel.userName}.",
            style: AppTextStyles.title,
          ),
          const SizedBox(height: 6),
          Text("You're doing great today!", style: AppTextStyles.subtitle),
          const SizedBox(height: 20),

          StreakCard(viewModel: viewModel),
          const SizedBox(height: 20),

          VoiceTestCard(onTap: () => viewModel.startVoiceTest(context)),
          const SizedBox(height: 20),

          FaceTestCard(onTap: () => viewModel.startFaceTest(context)),
          const SizedBox(height: 20),

          TremorTestCard(onTap: () => viewModel.startTremorTest(context)),
          const SizedBox(height: 20),

          // const Text("Overview", style: AppTextStyles.cardTitle),
          // const SizedBox(height: 12),

          // LatestCheckupCard(onTap: () => viewModel.openDetails(context)),
          // const SizedBox(height: 16),
          DailyTipCard(tip: AppStrings.dailyTip),
        ],
      ),
    );
  }
}
