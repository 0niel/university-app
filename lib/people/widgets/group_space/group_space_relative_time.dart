import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

String groupSpaceRelativeTime(BuildContext context, DateTime? date) {
  if (date == null) return '';
  final difference = DateTime.now().difference(date.toLocal());
  if (difference.inMinutes < 1) return context.l10n.lostFoundJustNow;
  if (difference.inMinutes < 60) {
    return context.l10n.groupSpaceTimeMinutes(difference.inMinutes);
  }
  if (difference.inHours < 24) {
    return context.l10n.groupSpaceTimeHours(difference.inHours);
  }
  if (difference.inDays == 1) return context.l10n.groupSpaceTimeYesterday;
  return context.l10n.groupSpaceTimeDays(difference.inDays);
}
