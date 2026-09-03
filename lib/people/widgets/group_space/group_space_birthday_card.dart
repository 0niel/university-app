import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class GroupSpaceBirthdayCard extends StatelessWidget {
  const GroupSpaceBirthdayCard({required this.birthday, super.key});

  final GroupBirthday birthday;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final today = birthday.daysLeft == 0;
    final countdown = switch (birthday.daysLeft) {
      0 => l10n.groupSpaceBirthdayToday,
      1 => l10n.groupSpaceBirthdayTomorrow,
      final days => l10n.groupSpaceBirthdayInDays(days),
    };
    return Container(
      width: 116,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: today ? colors.tint : colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          NinjaAvatar(initials: ninjaInitials(birthday.name)),
          const SizedBox(height: 8),
          Text(
            birthday.isMe ? l10n.groupSpaceBirthdayYou : birthday.name,
            maxLines: 2,
            textAlign: .center,
            overflow: .ellipsis,
            style: AppText.caption.copyWith(
              fontWeight: .w700,
              color: colors.ink,
            ),
          ),
          Text(
            DateFormat.MMMd(
              Localizations.localeOf(context).languageCode,
            ).format(birthday.date),
            style: AppText.captionSmall.copyWith(color: colors.muted),
          ),
          const SizedBox(height: 4),
          AppBadge(
            label: countdown,
            tone: today ? .accent : .neutral,
          ),
        ],
      ),
    );
  }
}
