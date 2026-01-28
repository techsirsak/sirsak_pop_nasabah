import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String get toDayRelative {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transactionDate = DateTime(year, month, day);

    if (transactionDate == today) {
      return 'Today, ${DateFormat('h:mm a').format(this)}';
    } else if (transactionDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday, ${DateFormat('h:mm a').format(this)}';
    } else {
      return DateFormat('d MMM yyyy, h:mm a').format(this);
    }
  }
}
