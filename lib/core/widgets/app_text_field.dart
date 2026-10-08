import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// A labelled text input: a small label above, then a bordered box with
/// an optional icon on the left.
///
/// It is a `StatefulWidget` because of the password eye: the widget has
/// to remember, by itself, whether the text is currently hidden.
///
/// Example:
/// ```dart
/// AppTextField(
///   label: 'Email',
///   hint: 'you@school.edu',
///   prefixIcon: Icons.mail_outline,
/// )
///
/// AppTextField(
///   label: 'Password',
///   isPassword: true,
///   prefixIcon: Icons.lock_outline,
///   errorText: 'Password is too short',
/// )
/// ```
class AppTextField extends StatefulWidget {
  /// Small label drawn above the box. Pass null for no label.
  final String? label;

  /// Grey placeholder text inside the box.
  final String? hint;

  /// Holds and reads the typed text.
  final TextEditingController? controller;

  /// Icon on the left inside the box.
  final IconData? prefixIcon;

  /// Widget on the right inside the box. Ignored when [isPassword] is
  /// true, because the eye button takes that spot.
  final Widget? suffix;

  /// Hides the text and shows an eye button to reveal it.
  final bool isPassword;

  /// Red message under the box. Pass null when there is no error.
  final String? errorText;

  /// Which on-screen keyboard to show.
  final TextInputType? keyboardType;

  /// Greys the field out and blocks typing.
  final bool enabled;

  /// Number of visible lines. Forced to 1 for a password field.
  final int maxLines;

  /// Fired on every keystroke.
  final ValueChanged<String>? onChanged;

  /// Fired when the user presses the keyboard action button.
  final ValueChanged<String>? onSubmitted;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.prefixIcon,
    this.suffix,
    this.isPassword = false,
    this.errorText,
    this.keyboardType,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  /// True while a password is hidden behind dots.
  late bool _obscured = widget.isPassword;

  void _toggleObscured() => setState(() => _obscured = !_obscured);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.sm - 2),
        ],
        TextField(
          controller: widget.controller,
          obscureText: _obscured,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          style: AppTextStyles.body,
          // Everything visual (fill, radius, borders, colours) comes
          // from inputDecorationTheme in AppTheme.
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon == null
                ? null
                : Icon(widget.prefixIcon, size: AppSizes.iconSm),
            suffixIcon: _buildSuffix(),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffix() {
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: AppSizes.iconSm,
          color: AppColors.textMuted,
        ),
        tooltip: _obscured ? 'Show password' : 'Hide password',
        onPressed: _toggleObscured,
      );
    }
    return widget.suffix;
  }
}
