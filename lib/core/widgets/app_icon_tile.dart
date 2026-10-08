import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// The small rounded square with a pale background and a coloured icon
/// in the middle. It shows up on list rows, stat cards and menus all
/// over the Figma file, so it lives here instead of being rebuilt each
/// time.
///
/// Example:
/// ```dart
/// AppIconTile(
///   icon: Icons.school_outlined,
///   color: AppColors.info,
///   background: AppColors.infoSoft,
/// )
/// ```
class AppIconTile extends StatelessWidget {
  /// The icon to draw. Use Flutter built-in [Icons].
  final IconData icon;

  /// Colour of the icon itself.
  final Color color;

  /// Pale colour behind the icon. Usually the matching `...Soft` colour.
  final Color background;

  /// Width and height of the square.
  final double size;

  const AppIconTile({
    super.key,
    required this.icon,
    this.color = AppColors.primary,
    this.background = AppColors.infoSoft,
    this.size = AppSizes.iconTile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.borderSm,
      ),
      // The icon scales with the tile so a bigger tile is not mostly
      // empty space.
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}
