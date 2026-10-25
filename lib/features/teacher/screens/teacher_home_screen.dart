import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/metrics.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/view_state_builder.dart';
import '../../../routes/app_routes.dart';
import '../../district/widgets/exam_list_tile.dart';
import '../controllers/teacher_dashboard_controller.dart';

/// Teacher Home Dashboard displaying assigned school metrics, shortcuts, and upcoming exams.
class TeacherHomeScreen extends StatefulWidget {
  final TeacherDashboardController controller;
  final String? schoolId;
  final VoidCallback? onNavigateToAttendance;
  final VoidCallback? onNavigateToExams;

  const TeacherHomeScreen({
    super.key,
    required this.controller,
    this.schoolId,
    this.onNavigateToAttendance,
    this.onNavigateToExams,
  });

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  @override
  void initState() {
    super.initState();
    if (!widget.controller.state.isReady) {
      widget.controller.load(schoolId: widget.schoolId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return ViewStateBuilder(
          state: widget.controller.state,
          onRetry: () => widget.controller.load(schoolId: widget.schoolId),
          builder: (context, data) => _buildBody(context, data),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, TeacherDashboardData data) {
    final teacher = data.teacherProfile;
    final school = data.school;

    return RefreshIndicator(
      onRefresh: () => widget.controller.load(schoolId: widget.schoolId),
      child: ListView(
        padding: AppSpacing.paddingScreen,
        children: [
          // Greeting & Profile Summary Card
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Welcome back, ${teacher.name}',
                        style: AppTextStyles.cardTitle,
                      ),
                    ),
                    const StatusBadge(label: 'Teacher', type: StatusType.info),
                  ],
                ),
                if (school != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${school.schoolName} • ${school.location}',
                    style: AppTextStyles.bodySecondary,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Stat Cards Summary Grid
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.groups_outlined,
                  label: 'Total Students',
                  value: '${data.totalStudents}',
                  iconColor: AppColors.info,
                  iconBackground: AppColors.infoSoft,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: StatCard(
                  icon: Icons.fact_check_outlined,
                  label: 'Attendance Rate',
                  value: Metrics.formatPercent(data.attendanceRate),
                  iconColor: AppColors.success,
                  iconBackground: AppColors.successSoft,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Quick Action Shortcuts
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quick Actions', style: AppTextStyles.sectionHeading),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Mark Attendance',
                        icon: Icons.fact_check,
                        onPressed: widget.onNavigateToAttendance,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppButton(
                        label: 'View Schedule',
                        isOutlined: true,
                        icon: Icons.assignment_outlined,
                        onPressed: widget.onNavigateToExams,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Upcoming School Exams Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming School Exams',
                style: AppTextStyles.sectionHeading,
              ),
              if (data.upcomingExams.isNotEmpty)
                TextButton(
                  onPressed: widget.onNavigateToExams,
                  child: const Text('View All'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          if (data.upcomingExams.isEmpty)
            const AppCard(
              child: Text(
                'No upcoming exams scheduled for your school right now.',
                style: AppTextStyles.bodySecondary,
              ),
            )
          else
            ...data.upcomingExams
                .take(3)
                .map(
                  (exam) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ExamListTile(
                      exam: exam,
                      schoolName: school?.schoolName,
                      onTap: (_) {
                        Navigator.of(context).pushNamed(
                          AppRoutes.examDetails,
                          arguments: exam.examId,
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
