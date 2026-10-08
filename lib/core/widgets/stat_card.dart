import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_card.dart';
import 'app_icon_tile.dart';

/// The small summary card on dashboards: a coloured icon tile, a label,
/// and one big number. e.g. "Total Students / 1,284".
///
/// It is built to sit in a two-column grid, so it does not set its own
/// width. The caller decides, usually with a `GridView` or a `Row` of
/// `Expanded` widgets.
///
/// Example:
/// ```dart
/// StatCard(
///   icon: Icons.groups_outlined,
///   label: 'Total Students',
///   value: '1,284',
///   iconColor: AppColors.info,
///   iconBackground: AppColors.infoSoft,
/// )
/// ```
class StatCard extends StatelessWidget {
  /// Icon in the coloured tile.
  final IconData icon;

  /// The small grey description, e.g. 'Total Students'.
  final String label;

  /// The big number, already formatted as text by the caller.
  final String value;

  /// Colour of the icon.
  final Color iconColor;

  /// Pale colour behind the icon.
  final Color iconBackground;

  /// Optional small line under the number, e.g. '+12 this week'.
  final String? caption;

  /// Optional tap, for cards that open a detail screen.
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = AppColors.primary,
    this.iconBackground = AppColors.infoSoft,
    this.caption,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIconTile(
            icon: icon,
            color: iconColor,
            background: iconBackground,
            size: AppSizes.iconTileLarge,
          ),
          const SizedBox(height: AppSpacing.ms),
          Text(
            label,
            style: AppTextStyles.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.statNumber,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (caption != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              caption!,
              style: AppTextStyles.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
