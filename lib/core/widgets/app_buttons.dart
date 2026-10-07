import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Shared inner content for all three buttons: either a spinner, or an
/// optional icon followed by the label.
class _ButtonBody extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isLoading;
  final Color spinnerColor;

  const _ButtonBody({
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.spinnerColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: AppSizes.iconSm,
        width: AppSizes.iconSm,
        child: CircularProgressIndicator(
          strokeWidth: AppSizes.spinnerStroke,
          color: spinnerColor,
        ),
      );
    }

    if (icon == null) return Text(label);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSizes.iconSm),
        const SizedBox(width: AppSpacing.sm),
        Text(label),
      ],
    );
  }
}

/// The main navy button. Use it for the one most important action on a
/// screen: Sign In, Save, Submit.
///
/// It is full width by default, because that is how it looks in Figma.
/// Pass `fullWidth: false` to make it hug its label.
///
/// Passing `onPressed: null` disables it. Passing `isLoading: true`
/// shows a spinner and blocks taps.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: _ButtonBody(
        label: label,
        icon: icon,
        isLoading: isLoading,
        spinnerColor: AppColors.textOnPrimary,
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// The white button with a thin grey border. Use it for the secondary
/// action next to a [PrimaryButton]: Cancel, Back, View Details.
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      child: _ButtonBody(
        label: label,
        icon: icon,
        isLoading: isLoading,
        spinnerColor: AppColors.primary,
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// The red button. Use it only for destructive or sign-out actions:
/// Delete Student, Log Out.
///
/// It reuses the elevated button shape from the theme and only swaps
/// the background colour, so it keeps the same height and radius.
class DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const DangerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.danger,
        foregroundColor: AppColors.textOnPrimary,
        disabledBackgroundColor: AppColors.disabled,
        disabledForegroundColor: AppColors.textMuted,
      ),
      child: _ButtonBody(
        label: label,
        icon: icon,
        isLoading: isLoading,
        spinnerColor: AppColors.textOnPrimary,
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
