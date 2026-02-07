import 'package:application/features/facial_check/facial_check_view.dart';
import 'package:application/features/history/history_view.dart';
import 'package:application/features/shell/main_shell_view.dart';
import 'package:flutter/material.dart';
import '../../features/onboarding/onboarding_view.dart';
import '../../features/voice_check/voice_check_view.dart';
import '../../features/processing/voice_processing_view.dart';
import '../../features/results/results_view.dart';
import '../../features/tremor_check/tremor_check_view.dart';
import '../../features/tremor_check/tremor_processing_view.dart';
import '../../features/tremor_check/tremor_results_view.dart';
import '../../features/caregiver/caregiver_dashboard_view.dart';
import '../../features/doctor/doctor_dashboard_view.dart';

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
        return MaterialPageRoute(builder: (_) => const FacialCheckView());
      case '/tremor':
        return MaterialPageRoute(builder: (_) => const TremorCheckView());
      case '/tremor_processing':
        return MaterialPageRoute(builder: (_) => const TremorProcessingView());
      case '/tremor_results':
        return MaterialPageRoute(
          builder: (_) => const TremorResultsView(),
          settings: settings,
        );
      case '/caregiver_dashboard':
        return MaterialPageRoute(builder: (_) => const CaregiverDashboardView());
      case '/doctor_dashboard':
        return MaterialPageRoute(builder: (_) => const DoctorDashboardView());
      default:
        return MaterialPageRoute(builder: (_) => const OnboardingView());
    }
  }
}
