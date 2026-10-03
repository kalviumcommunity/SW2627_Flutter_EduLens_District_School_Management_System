import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand / Primary Palette
  static const Color primary = Color(0xFF1E3A8A); // Deep Slate Navy
  static const Color primaryLight = Color(0xFF3B82F6); // Royal Blue
  static const Color secondary = Color(0xFF059669); // Emerald Green

  // Neutral Palette
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color surface = Color(0xFFFFFFFF); // Pure White
  static const Color border = Color(0xFFE2E8F0); // Slate 200
  static const Color divider = Color(0xFFF1F5F9); // Slate 100

  // Typography Colors
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400

  // Status & Feedback Colors
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color successBg = Color(0xFFECFDF5);

  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color warningBg = Color(0xFFFFFBEB);

  static const Color error = Color(0xFFEF4444); // Red
  static const Color errorBg = Color(0xFFFEF2F2);

  static const Color info = Color(0xFF3B82F6); // Blue
  static const Color infoBg = Color(0xFFEFF6FF);
}
