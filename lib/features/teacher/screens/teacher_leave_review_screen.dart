import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_screen_bar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/view_state_builder.dart';
import '../../../models/leave_request_model.dart';
import '../controllers/teacher_leave_review_controller.dart';

/// Screen allowing Teachers and Admins to review and approve/reject leave requests.
class TeacherLeaveReviewScreen extends StatefulWidget {
  final TeacherLeaveReviewController controller;
  final String schoolId;
  final String teacherId;

  const TeacherLeaveReviewScreen({
    super.key,
    required this.controller,
    required this.schoolId,
    required this.teacherId,
  });

  @override
  State<TeacherLeaveReviewScreen> createState() =>
      _TeacherLeaveReviewScreenState();
}

class _TeacherLeaveReviewScreenState extends State<TeacherLeaveReviewScreen> {
  String _filterStatus = 'Pending';

  @override
  void initState() {
    super.initState();
    widget.controller.loadSchoolRequests(widget.schoolId);
  }

  void _openReviewDialog(LeaveRequestModel req, String newStatus) {
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('$newStatus Leave Request', style: AppTextStyles.cardTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student: ${req.studentName} (${req.className})',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Dates: ${req.startDate} to ${req.endDate}',
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: commentController,
              label: 'Reviewer Comment (Optional)',
              hint: 'e.g. Approved for family emergency',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          AppButton(
            label: 'Confirm $newStatus',
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final success = await widget.controller.reviewRequest(
                schoolId: widget.schoolId,
                requestId: req.requestId,
                status: newStatus,
                teacherId: widget.teacherId,
                comment: commentController.text,
              );

              if (mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Leave request $newStatus successfully.'),
                    backgroundColor: newStatus == 'Approved'
                        ? AppColors.success
                        : AppColors.danger,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  StatusType _statusType(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return StatusType.success;
      case 'rejected':
        return StatusType.error;
      default:
        return StatusType.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppScreenBar.back(
            title: 'Review Leave Requests',
            onBack: () => Navigator.of(context).maybePop(),
          ),
          body: ViewStateBuilder<List<LeaveRequestModel>>(
            state: widget.controller.state,
            onRetry: () =>
                widget.controller.loadSchoolRequests(widget.schoolId),
            emptyTitle: 'No Leave Requests',
            builder: (context, requests) => _buildBody(context, requests),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, List<LeaveRequestModel> requests) {
    final filtered = requests.where((r) {
      if (_filterStatus == 'All') return true;
      return r.status.toLowerCase() == _filterStatus.toLowerCase();
    }).toList();

    return RefreshIndicator(
      onRefresh: () => widget.controller.loadSchoolRequests(widget.schoolId),
      child: ListView(
        padding: AppSpacing.paddingScreen,
        children: [
          Row(
            children: [
              ChoiceChip(
                label: const Text('Pending'),
                selected: _filterStatus == 'Pending',
                onSelected: (selected) {
                  if (selected) setState(() => _filterStatus = 'Pending');
                },
              ),
              const SizedBox(width: AppSpacing.xs),
              ChoiceChip(
                label: const Text('All Requests'),
                selected: _filterStatus == 'All',
                onSelected: (selected) {
                  if (selected) setState(() => _filterStatus = 'All');
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (filtered.isEmpty)
            const AppCard(
              child: Text(
                'No leave requests match the selected status.',
                style: AppTextStyles.bodySecondary,
              ),
            )
          else
            ...filtered.map(
              (req) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              req.studentName,
                              style: AppTextStyles.cardTitle,
                            ),
                          ),
                          StatusBadge(
                            label: req.status,
                            type: _statusType(req.status),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Class: ${req.className} • Submitted: ${req.submittedAt}',
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Dates: ${req.startDate} to ${req.endDate}',
                        style: AppTextStyles.body,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Reason: ${req.reason}',
                        style: AppTextStyles.bodySecondary,
                      ),
                      if (req.reviewComment != null &&
                          req.reviewComment!.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Comment: ${req.reviewComment}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ],
                      if (req.status.toLowerCase() == 'pending') ...[
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                label: 'Approve',
                                icon: Icons.check,
                                onPressed: () =>
                                    _openReviewDialog(req, 'Approved'),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: AppButton(
                                label: 'Reject',
                                isOutlined: true,
                                icon: Icons.close,
                                onPressed: () =>
                                    _openReviewDialog(req, 'Rejected'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
