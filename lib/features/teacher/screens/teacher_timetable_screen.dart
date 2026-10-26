import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_date.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_list_tile.dart';
import '../../../core/widgets/app_screen_bar.dart';
import '../../../core/widgets/view_state_builder.dart';
import '../../../models/timetable_model.dart';
import '../controllers/teacher_timetable_controller.dart';

/// Screen displaying the Teacher's daily/weekly class schedule.
class TeacherTimetableScreen extends StatefulWidget {
  final TeacherTimetableController controller;
  final String schoolId;
  final String teacherId;

  const TeacherTimetableScreen({
    super.key,
    required this.controller,
    required this.schoolId,
    required this.teacherId,
  });

  @override
  State<TeacherTimetableScreen> createState() => _TeacherTimetableScreenState();
}

class _TeacherTimetableScreenState extends State<TeacherTimetableScreen> {
  static const List<String> _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  void initState() {
    super.initState();
    widget.controller.loadTimetable(
      schoolId: widget.schoolId,
      teacherId: widget.teacherId,
    );
  }

  void _onDaySelected(String day) {
    widget.controller.loadTimetable(
      schoolId: widget.schoolId,
      teacherId: widget.teacherId,
      dayOfWeek: day,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppScreenBar.back(
            title: 'Class Timetable',
            onBack: () => Navigator.of(context).maybePop(),
          ),
          body: ViewStateBuilder<List<TimetableModel>>(
            state: widget.controller.state,
            onRetry: () => widget.controller.loadTimetable(
              schoolId: widget.schoolId,
              teacherId: widget.teacherId,
            ),
            emptyTitle: 'No Classes Scheduled',
            builder: (context, entries) => _buildBody(context, entries),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, List<TimetableModel> entries) {
    final activeDay = widget.controller.selectedDay;

    return RefreshIndicator(
      onRefresh: () => widget.controller.loadTimetable(
        schoolId: widget.schoolId,
        teacherId: widget.teacherId,
      ),
      child: ListView(
        padding: AppSpacing.paddingScreen,
        children: [
          // Day Choice Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _weekdays.map((day) {
                final isSelected = day.toLowerCase() == activeDay.toLowerCase();
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: ChoiceChip(
                    label: Text(day),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) _onDaySelected(day);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          if (entries.isEmpty)
            AppCard(
              child: Text(
                'No classes scheduled for $activeDay.',
                style: AppTextStyles.bodySecondary,
              ),
            )
          else
            ...entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _timetableCard(entry),
              ),
            ),
        ],
      ),
    );
  }

  Widget _timetableCard(TimetableModel entry) {
    final formattedStart = AppDate.formatTime(entry.startTime);
    final formattedEnd = AppDate.formatTime(entry.endTime);
    final timeRange = '$formattedStart – $formattedEnd';

    final roomText = (entry.roomNumber != null && entry.roomNumber!.isNotEmpty)
        ? ' • Room: ${entry.roomNumber}'
        : '';

    return AppListTile(
      icon: Icons.class_outlined,
      iconColor: AppColors.info,
      iconBackground: AppColors.infoSoft,
      title: '${entry.subject} (${entry.className}-${entry.section})',
      subtitle: '$timeRange$roomText',
      showChevron: false,
    );
  }
}
