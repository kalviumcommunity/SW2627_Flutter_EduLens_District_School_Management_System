import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../models/student_model.dart';
import '../controllers/student_leave_request_controller.dart';

/// Modal dialog for student leave request submission.
class SubmitLeaveRequestDialog extends StatefulWidget {
  final StudentModel student;
  final StudentLeaveRequestController controller;
  final VoidCallback onSubmitted;

  const SubmitLeaveRequestDialog({
    super.key,
    required this.student,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  State<SubmitLeaveRequestDialog> createState() =>
      _SubmitLeaveRequestDialogState();
}

class _SubmitLeaveRequestDialogState extends State<SubmitLeaveRequestDialog> {
  final _startDateController = TextEditingController(text: '2026-10-25');
  final _endDateController = TextEditingController(text: '2026-10-26');
  final _reasonController = TextEditingController();

  String? _validationError;

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  bool _validate() {
    final start = _startDateController.text.trim();
    final end = _endDateController.text.trim();
    final reason = _reasonController.text.trim();

    if (start.isEmpty || end.isEmpty) {
      setState(
        () => _validationError = 'Please specify both start and end dates.',
      );
      return false;
    }

    if (start.compareTo(end) > 0) {
      setState(() => _validationError = 'Start date cannot be after end date.');
      return false;
    }

    if (reason.isEmpty) {
      setState(
        () => _validationError = 'Please enter a valid reason for leave.',
      );
      return false;
    }

    setState(() => _validationError = null);
    return true;
  }

  Future<void> _submit() async {
    if (!_validate()) return;

    final success = await widget.controller.submitLeaveRequest(
      student: widget.student,
      startDate: _startDateController.text,
      endDate: _endDateController.text,
      reason: _reasonController.text,
    );

    if (mounted && success) {
      Navigator.of(context).pop();
      widget.onSubmitted();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = widget.controller.isSubmitting;

    return AlertDialog(
      title: const Text(
        'Request Student Leave',
        style: AppTextStyles.cardTitle,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: _startDateController,
              label: 'Start Date (yyyy-MM-dd)',
              hint: 'e.g. 2026-10-25',
              enabled: !isSubmitting,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _endDateController,
              label: 'End Date (yyyy-MM-dd)',
              hint: 'e.g. 2026-10-26',
              enabled: !isSubmitting,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _reasonController,
              label: 'Reason for Leave',
              hint: 'e.g. Medical emergency or family event',
              enabled: !isSubmitting,
            ),
            if (_validationError != null ||
                widget.controller.submitError != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                _validationError ?? widget.controller.submitError!,
                style: AppTextStyles.caption.copyWith(color: AppColors.danger),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: 'Submit Request',
          isLoading: isSubmitting,
          onPressed: isSubmitting ? null : _submit,
        ),
      ],
    );
  }
}
