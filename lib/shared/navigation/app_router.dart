import 'package:application/features/facial_check/facial_check_view.dart';
import 'package:application/features/history/history_view.dart';
import 'package:application/features/shell/main_shell_view.dart';
import 'package:flutter/material.dart';
import '../../features/onboarding/onboarding_view.dart';
import '../../features/voice_check/voice_check_view.dart';
import '../../features/processing/voice_processing_view.dart';
import '../../features/results/results_view.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const OnboardingView());
      case '/home':
        return MaterialPageRoute(builder: (_) => const MainShellView());
      case '/voice':
        return MaterialPageRoute(builder: (_) => const VoiceCheckView());
      case '/processing':
        return MaterialPageRoute(
          builder: (_) => const VoiceProcessingView(),
          settings: settings,
        );
      case '/results':
        return MaterialPageRoute(
          builder: (_) => const ResultsView(),
          settings: settings, // ✅ THIS LINE FIXES EVERYTHING
        );
      case '/history':
        return MaterialPageRoute(builder: (_) => HistoryView());
      case '/face':
        // Placeholder for Face Test View
        return MaterialPageRoute(builder: (_) => const FacialCheckView());
      case '/tremor':
        // Placeholder for Tremor Test View
        return MaterialPageRoute(builder: (_) => const Placeholder());
      default:
        return MaterialPageRoute(builder: (_) => const OnboardingView());
    }
  }
}
