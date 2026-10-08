import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// The statuses EduLens shows in a chip.
///
/// Fees use [paid] / [partial] / [outstanding].
/// Attendance uses [present] / [absent].
enum StatusChipType { paid, partial, outstanding, present, absent }

/// A small pill showing a status, e.g. a green "Paid" or a red "Absent".
///
/// You only pass the [type]. The label and the colours are decided here
/// so the same status always looks the same everywhere.
///
/// Example:
/// ```dart
/// StatusChip(type: StatusChipType.paid)
/// StatusChip(type: StatusChipType.absent, label: 'Absent (2)')
/// ```
class StatusChip extends StatelessWidget {
  /// Which status to show.
  final StatusChipType type;

  /// Optional override for the text. Leave it out to use the default
  /// label for the [type].
  final String? label;

  const StatusChip({super.key, required this.type, this.label});

  /// Default text for each status.
  String get _defaultLabel {
    switch (type) {
      case StatusChipType.paid:
        return 'Paid';
      case StatusChipType.partial:
        return 'Partial';
      case StatusChipType.outstanding:
        return 'Outstanding';
      case StatusChipType.present:
        return 'Present';
      case StatusChipType.absent:
        return 'Absent';
    }
  }

  /// Strong colour, used for the text.
  Color get _foreground {
    switch (type) {
      case StatusChipType.paid:
      case StatusChipType.present:
        return AppColors.success;
      case StatusChipType.partial:
        return AppColors.warning;
      case StatusChipType.outstanding:
      case StatusChipType.absent:
        return AppColors.danger;
    }
  }

  /// Pale colour, used for the pill background.
  Color get _background {
    switch (type) {
      case StatusChipType.paid:
      case StatusChipType.present:
        return AppColors.successSoft;
      case StatusChipType.partial:
        return AppColors.warningSoft;
      case StatusChipType.outstanding:
      case StatusChipType.absent:
        return AppColors.dangerSoft;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.ms,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: AppRadius.borderPill,
      ),
      child: Text(
        label ?? _defaultLabel,
        style: AppTextStyles.chipLabel.copyWith(color: _foreground),
      ),
    );
  }
}
