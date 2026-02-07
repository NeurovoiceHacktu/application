import 'package:flutter/material.dart';

class HomeViewModel {
  String userName = "Arthur";
  int streakDays = 3;
  int streakPercent = 75;

  void startVoiceTest(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushNamed('/voice');
  }

  void startFaceTest(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushNamed('/face');
  }

  void startTremorTest(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushNamed('/tremor');
  }

  void openDetails(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushNamed('/history');
  }

  void openCaregiverDashboard(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushNamed('/caregiver_dashboard');
  }

  void openDoctorDashboard(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushNamed('/doctor_dashboard');
  }
}
