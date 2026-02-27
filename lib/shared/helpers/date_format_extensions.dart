import 'package:intl/intl.dart';
import 'package:sirsak_pop_nasabah/gen/l10n/app_localizations.dart';

extension DateTimeX on DateTime {
  String toDayRelative(AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transactionDate = DateTime(year, month, day);
    final locale = l10n.localeName;

    final timeFormat = DateFormat('h:mm a', locale).format(this);

    if (transactionDate == today) {
      return '${l10n.dateToday}, $timeFormat';
    } else if (transactionDate == today.subtract(const Duration(days: 1))) {
      return '${l10n.dateYesterday}, $timeFormat';
    } else {
      return DateFormat('d MMM yyyy, h:mm a', locale).format(this);
    }
  }

  String toScheduleRelative(AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scheduleDate = DateTime(year, month, day);
    final locale = l10n.localeName;

    final timeFormat = DateFormat('h:mm a', locale).format(this);

    if (scheduleDate == today) {
      return '${l10n.dateToday}, $timeFormat';
    } else if (scheduleDate == today.add(const Duration(days: 1))) {
      return '${l10n.dateTomorrow}, $timeFormat';
    } else {
      return DateFormat('d MMM yyyy', locale).format(this);
    }
  }
}
