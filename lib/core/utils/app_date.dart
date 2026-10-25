/// Parsing and formatting for the date strings EduLens stores.
///
/// Dates are stored as `yyyy-MM-dd` text and times as `HH:mm`, as fixed in
/// the Day 5 data-model gap report. That format matters twice over: it
/// parses with `DateTime.parse` without a custom parser, and it sorts
/// chronologically as plain text.
///
/// Everything here is deliberately lenient about *reading*: a record with
/// an unparseable date is reported as null rather than throwing, so one
/// malformed document cannot take a whole screen down.
abstract class AppDate {
  /// Parses a stored `yyyy-MM-dd` date, or null when it is missing or
  /// malformed.
  ///
  /// Returns a date at midnight local time, so comparisons are about the
  /// calendar day and not the moment within it.
  static DateTime? tryParse(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = DateTime.tryParse(value.trim());
    if (parsed == null) return null;
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  /// Today, with the time stripped.
  static DateTime today([DateTime? now]) {
    final n = now ?? DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  /// Whether [value] falls on or after [from].
  ///
  /// An exam held later today still counts as upcoming — the comparison is
  /// by day, so it does not disappear from the list part-way through its
  /// own date.
  static bool isOnOrAfter(String? value, DateTime from) {
    final date = tryParse(value);
    if (date == null) return false;
    return !date.isBefore(from);
  }

  /// Whether [value] falls within [days] days of [from], inclusive of both
  /// ends.
  static bool isWithinDays(String? value, DateTime from, int days) {
    final date = tryParse(value);
    if (date == null) return false;
    if (date.isBefore(from)) return false;
    return !date.isAfter(from.add(Duration(days: days)));
  }

  /// A stored date rendered for display, e.g. `16 Oct 2026`.
  ///
  /// Unparseable input is handed back unchanged rather than replaced with
  /// a placeholder, so bad data stays visible instead of looking tidy.
  static String formatLong(String? value) {
    final date = tryParse(value);
    if (date == null) return value ?? '';
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  /// Formats a stored 24-hour `HH:mm` time string into a 12-hour AM/PM time.
  ///
  /// Examples:
  /// - `00:00` -> `12:00 AM`
  /// - `09:05` -> `9:05 AM`
  /// - `12:00` -> `12:00 PM`
  /// - `14:00` -> `2:00 PM`
  /// - `16:45` -> `4:45 PM`
  /// - `23:59` -> `11:59 PM`
  ///
  /// Safe fallbacks handle null, empty, or unparseable input without crashing.
  static String formatTime(String? value) {
    if (value == null || value.trim().isEmpty) return 'Time not available';
    final trimmed = value.trim();

    final upper = trimmed.toUpperCase();
    if (upper.contains('AM') || upper.contains('PM')) {
      return trimmed;
    }

    final parts = trimmed.split(':');
    if (parts.length != 2) return trimmed;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) return trimmed;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return trimmed;

    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');

    return '$displayHour:$displayMinute $period';
  }

  /// A stored date and time together, e.g. `16 Oct 2026 · 10:00 AM`.
  static String formatWithTime(String? date, String? time) {
    final day = formatLong(date);
    if (time == null || time.trim().isEmpty) return day;
    final formattedTime = formatTime(time);
    if (formattedTime == 'Time not available') return day;
    return '$day · $formattedTime';
  }

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
}
