import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Every text style used in EduLens.
///
/// Widgets should use a named style from here (or `Theme.of(context)
/// .textTheme...`) instead of writing their own font size and weight.
///
/// The font family is deliberately NOT set, so Flutter uses the system
/// font (Roboto on Android, SF Pro on iOS). To switch to Inter later,
/// add the font and set `fontFamily: 'Inter'` once in [AppTheme].
abstract class AppTextStyles {
  /// Big bold title at the top of a screen. e.g. "Good morning, Aditya".
  static const TextStyle screenTitle = TextStyle(
    fontSize: 24.0, // TODO verify vs Figma
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.4,
    color: AppColors.textPrimary,
  );

  /// Heading above a group of cards. e.g. "Recent Activity".
  static const TextStyle sectionHeading = TextStyle(
    fontSize: 18.0, // TODO verify vs Figma
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  /// Title inside a white card, or the main line of a list row.
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16.0, // TODO verify vs Figma
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  /// Normal paragraph text.
  static const TextStyle body = TextStyle(
    fontSize: 14.0, // TODO verify vs Figma
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  /// Normal text in the softer grey, used for subtitles.
  static const TextStyle bodySecondary = TextStyle(
    fontSize: 14.0, // TODO verify vs Figma
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: AppColors.textSecondary,
  );

  /// Small label above an input, or a timestamp.
  static const TextStyle caption = TextStyle(
    fontSize: 12.0, // TODO verify vs Figma
    fontWeight: FontWeight.w500,
    height: 1.35,
    color: AppColors.textSecondary,
  );

  /// The large number on a stat card. e.g. "1,284".
  static const TextStyle statNumber = TextStyle(
    fontSize: 28.0, // TODO verify vs Figma
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -0.6,
    color: AppColors.textPrimary,
  );

  /// Text inside a button.
  static const TextStyle buttonLabel = TextStyle(
    fontSize: 15.0, // TODO verify vs Figma
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.1,
  );

  /// Text inside a small status chip.
  static const TextStyle chipLabel = TextStyle(
    fontSize: 12.0, // TODO verify vs Figma
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// Label under a bottom navigation icon.
  static const TextStyle navLabel = TextStyle(
    fontSize: 11.0, // TODO verify vs Figma
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  /// Grey placeholder text inside a text input.
  static const TextStyle inputHint = TextStyle(
    fontSize: 14.0, // TODO verify vs Figma
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: AppColors.textMuted,
  );

  /// Red error message under a text input.
  static const TextStyle inputError = TextStyle(
    fontSize: 12.0, // TODO verify vs Figma
    fontWeight: FontWeight.w500,
    height: 1.35,
    color: AppColors.danger,
  );

  /// A blue, tappable piece of text. e.g. "Forgot password?".
  static const TextStyle link = TextStyle(
    fontSize: 14.0, // TODO verify vs Figma
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.accent,
  );

  /// The map Flutter itself uses. Built from the named styles above so
  /// there is still only one source of truth.
  static const TextTheme textTheme = TextTheme(
    headlineLarge: screenTitle,
    headlineMedium: sectionHeading,
    headlineSmall: statNumber,
    titleLarge: sectionHeading,
    titleMedium: cardTitle,
    titleSmall: caption,
    bodyLarge: body,
    bodyMedium: bodySecondary,
    bodySmall: caption,
    labelLarge: buttonLabel,
    labelMedium: chipLabel,
    labelSmall: navLabel,
  );
}
