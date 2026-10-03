import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

abstract class AppTypography {
  static const TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      letterSpacing: -0.5,
    ),
    headlineMedium: TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      letterSpacing: -0.3,
    ),
    titleLarge: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondary,
    ),
    labelLarge: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    labelSmall: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: AppColors.textMuted,
    ),
  );
}
