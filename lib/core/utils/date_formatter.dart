import 'package:intl/intl.dart';

class DateFormatter {
  static String formatShort(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM d').format(date);
  }

  static String formatFull(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String formatIsoDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static bool isOverdue(DateTime? dueDate, bool isCompleted) {
    if (dueDate == null || isCompleted) return false;
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    return dueDate.isBefore(startOfToday);
  }

  static bool isDueToday(DateTime? dueDate) {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate.year == now.year && dueDate.month == now.month && dueDate.day == now.day;
  }
}
