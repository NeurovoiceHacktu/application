import 'package:flutter/material.dart';

class OnboardingViewModel {
  void getStarted(BuildContext context) {
    // Later: save onboarding complete flag, permissions, etc.
    
    Navigator.pushNamed(
      context,
      '/home',
    );
  }
}