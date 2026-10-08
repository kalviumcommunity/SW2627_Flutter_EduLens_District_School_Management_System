import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_icon_tile.dart';

/// A stand-in for a screen that has not been built yet.
///
/// The app shell needs something to show behind each bottom navigation
/// tab so the navigation can actually be used and checked. This is that
/// something: a title, an icon and a short note saying the real screen
/// is still to come.
///
/// It holds no data and no logic. Each real screen replaces one of
/// these later.
///
/// Example:
/// ```dart
/// PlaceholderDestination(
///   title: 'Schools',
///   icon: Icons.apartment_outlined,
/// )
/// ```
class PlaceholderDestination extends StatelessWidget {
  /// Name of the screen this stands in for.
  final String title;

  /// Icon shown above the title, usually the tab icon.
  final IconData icon;

  /// Optional replacement for the default note.
  final String? note;

  const PlaceholderDestination({
    super.key,
    required this.title,
    required this.icon,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIconTile(
              icon: icon,
              color: AppColors.primary,
              background: AppColors.infoSoft,
              size: AppSizes.iconXl,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: AppTextStyles.sectionHeading,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              note ?? 'This screen has not been built yet.',
              style: AppTextStyles.bodySecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
