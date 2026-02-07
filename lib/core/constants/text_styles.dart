import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const title = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  static const cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const stepText = TextStyle(
    fontSize: 14,
    letterSpacing: 1,
    color: AppColors.primaryBlue,
    fontWeight: FontWeight.w600,
  );

  static const timer = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
}