import 'package:flutter/foundation.dart';

import '../../../core/state/safe_notifier.dart';
import '../../../core/state/view_state.dart';
import '../../../models/timetable_model.dart';
import '../../../repositories/timetable_repository.dart';

/// Drives the Teacher Weekly Timetable screen.
class TeacherTimetableController extends ChangeNotifier with SafeNotifier {
  final TimetableRepository timetableRepository;

  TeacherTimetableController({required this.timetableRepository});

  ViewState<List<TimetableModel>> _state = const ViewState.loading();
  ViewState<List<TimetableModel>> get state => _state;

  String _selectedDay = 'Monday';
  String get selectedDay => _selectedDay;

  /// Loads timetable entries for [schoolId] and [teacherId] on [dayOfWeek].
  Future<void> loadTimetable({
    required String schoolId,
    required String teacherId,
    String? dayOfWeek,
  }) async {
    _selectedDay = dayOfWeek ?? _selectedDay;
    _state = const ViewState.loading();
    safeNotify();

    try {
      final entries = await timetableRepository.getTimetableByTeacherAndDay(
        schoolId: schoolId,
        teacherId: teacherId,
        dayOfWeek: _selectedDay,
      );

      _state = ViewState.ready(entries);
    } catch (e) {
      _state = ViewState.fromError(e);
    }

    safeNotify();
  }
}
