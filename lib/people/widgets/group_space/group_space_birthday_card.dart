import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';

class GroupSpaceBirthdayCard extends StatelessWidget {
  const GroupSpaceBirthdayCard({required this.birthday, super.key});

  final GroupBirthday birthday;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return SizedBox(
      width: 112,
      child: Column(
        mainAxisAlignment: .center,
        children: [
          NinjaAvatar(initials: ninjaInitials(birthday.name)),
          const SizedBox(height: 8),
          Text(
            birthday.name,
            maxLines: 2,
            textAlign: .center,
            overflow: .ellipsis,
            style: NinjaText.helper.copyWith(
              fontWeight: .w700,
              color: colors.ink,
            ),
          ),
          Text(
            DateFormat.MMMd(
              Localizations.localeOf(context).languageCode,
            ).format(birthday.date),
            style: NinjaText.helper.copyWith(color: colors.muted),
          ),
        ],
      ),
    );
  }
}
