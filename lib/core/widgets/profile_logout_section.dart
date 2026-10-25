import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';
import 'app_card.dart';
import 'app_list_tile.dart';

/// Shared Profile and Logout widget embedded across all four role shells.
///
/// Handles session display, confirmation modal dialogs, duplicate sign-out
/// prevention, error handling, and clearing the navigation stack on logout.
class ProfileLogoutSection extends StatefulWidget {
  final AuthService? authService;
  final String? roleTitle;
  final String? userName;
  final String? userEmail;

  const ProfileLogoutSection({
    super.key,
    this.authService,
    this.roleTitle,
    this.userName,
    this.userEmail,
  });

  /// Displays the confirmation dialog and executes sign-out.
  static Future<void> performLogout({
    required BuildContext context,
    required AuthService authService,
  }) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log Out', style: AppTextStyles.cardTitle),
        content: const Text(
          'Are you sure you want to log out of EduLens?',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          AppButton(
            label: 'Log Out',
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await authService.signOut();
      if (context.mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  State<ProfileLogoutSection> createState() => _ProfileLogoutSectionState();
}

class _ProfileLogoutSectionState extends State<ProfileLogoutSection> {
  late final AuthService _authService;
  bool _isSigningOut = false;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? AuthService();
  }

  Future<void> _handleLogout() async {
    if (_isSigningOut) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log Out', style: AppTextStyles.cardTitle),
        content: const Text(
          'Are you sure you want to log out of EduLens?',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          AppButton(
            label: 'Log Out',
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isSigningOut = true);

    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSigningOut = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final name = widget.userName ?? user?.displayName ?? 'EduLens User';
    final email = widget.userEmail ?? user?.email ?? 'user@edulens.org';
    final role = widget.roleTitle ?? 'EduLens Account';

    return ListView(
      padding: AppSpacing.paddingScreen,
      children: [
        AppCard(
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.infoSoft,
                child: const Icon(
                  Icons.person,
                  size: 32,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.cardTitle),
                    const SizedBox(height: AppSpacing.xs),
                    Text(email, style: AppTextStyles.bodySecondary),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs + 2,
                        vertical: AppSpacing.xs / 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.infoSoft,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        role,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.info,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Account Options', style: AppTextStyles.sectionHeading),
              const SizedBox(height: AppSpacing.sm),
              AppListTile(
                icon: Icons.security_outlined,
                title: 'Security & Active Session',
                subtitle: 'Firebase Authentication Protected',
                showChevron: false,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppListTile(
                icon: Icons.logout_outlined,
                iconColor: AppColors.danger,
                title: 'Log Out',
                subtitle: 'Sign out and return to login',
                showChevron: true,
                onTap: _isSigningOut ? null : _handleLogout,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          key: const Key('profile_logout_button'),
          label: 'Log Out',
          icon: Icons.logout,
          isLoading: _isSigningOut,
          onPressed: _isSigningOut ? null : _handleLogout,
        ),
      ],
    );
  }
}
