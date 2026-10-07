import 'package:flutter/material.dart';

/// Every colour used in EduLens lives here and nowhere else.
///
/// Widgets must never write a raw hex value. If a colour looks wrong
/// compared to the Figma file, change it here once and the whole app
/// updates.
///
/// All values marked `// TODO verify vs Figma` were read visually from
/// screenshots, so they are close but not guaranteed exact.
abstract class AppColors {
  // ---------------------------------------------------------------
  // Brand
  // ---------------------------------------------------------------

  /// Main dark navy. App bars, primary buttons, big numbers.
  static const Color primary = Color(0xFF1E3A8A); // TODO verify vs Figma

  /// Pressed / darker navy, used for button pressed states.
  static const Color primaryDark = Color(0xFF152C66); // TODO verify vs Figma

  /// Lighter navy-blue, used for selected icons and subtle brand fills.
  static const Color primaryLight = Color(0xFF3B82F6); // TODO verify vs Figma

  /// Link / accent blue. "Forgot password?", "View all", text links.
  static const Color accent = Color(0xFF2563EB); // TODO verify vs Figma

  // ---------------------------------------------------------------
  // Neutrals
  // ---------------------------------------------------------------

  /// Page background. The light grey-blue behind all the white cards.
  static const Color background = Color(0xFFF4F7FB); // TODO verify vs Figma

  /// Card / sheet / app bar background. Pure white.
  static const Color surface = Color(0xFFFFFFFF);

  /// The 1px border around every white card and input.
  static const Color border = Color(0xFFE2E8F0); // TODO verify vs Figma

  /// Thin separator line inside lists.
  static const Color divider = Color(0xFFF1F5F9); // TODO verify vs Figma

  /// Background of a disabled button or input.
  static const Color disabled = Color(0xFFE8EDF4); // TODO verify vs Figma

  // ---------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------

  /// Headings, card titles, values. Almost black with a navy tint.
  static const Color textPrimary = Color(0xFF0F172A); // TODO verify vs Figma

  /// Subtitles, descriptions, helper text. Mid grey.
  static const Color textSecondary = Color(0xFF64748B); // TODO verify vs Figma

  /// Hints, placeholders, timestamps. Light grey.
  static const Color textMuted = Color(0xFF94A3B8); // TODO verify vs Figma

  /// Text drawn on top of [primary] / [danger] fills.
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------
  // Status (strong colours: text, icons, borders)
  // ---------------------------------------------------------------

  /// Paid, Present, verified.
  static const Color success = Color(0xFF16A34A); // TODO verify vs Figma

  /// Partial, pending, needs attention.
  static const Color warning = Color(0xFFD97706); // TODO verify vs Figma

  /// Outstanding, Absent, delete, errors.
  static const Color danger = Color(0xFFDC2626); // TODO verify vs Figma

  /// Neutral information.
  static const Color info = Color(0xFF2563EB); // TODO verify vs Figma

  // ---------------------------------------------------------------
  // Soft tints (pale fills behind status chips and icon tiles)
  // ---------------------------------------------------------------

  static const Color successSoft = Color(0xFFDCFCE7); // TODO verify vs Figma
  static const Color warningSoft = Color(0xFFFEF3C7); // TODO verify vs Figma
  static const Color dangerSoft = Color(0xFFFEE2E2); // TODO verify vs Figma
  static const Color infoSoft = Color(0xFFDBEAFE); // TODO verify vs Figma
  static const Color purpleSoft = Color(0xFFEDE9FE); // TODO verify vs Figma

  /// Strong purple that pairs with [purpleSoft] (exam / report icons).
  static const Color purple = Color(0xFF7C3AED); // TODO verify vs Figma

  // ---------------------------------------------------------------
  // Backwards-compatible aliases
  //
  // The first version of the theme used these names. They are kept so
  // older widgets keep compiling. Prefer the names above in new code.
  // ---------------------------------------------------------------

  static const Color secondary = success;
  static const Color error = danger;
  static const Color successBg = successSoft;
  static const Color warningBg = warningSoft;
  static const Color errorBg = dangerSoft;
  static const Color infoBg = infoSoft;
}
