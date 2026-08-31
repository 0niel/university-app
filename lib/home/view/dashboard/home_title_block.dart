import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/home/view/dashboard/home_day_status.dart';
import 'package:rtu_mirea_app/home/view/dashboard/home_day_status_kind.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'title_skeleton.dart';

class HomeTitleBlock extends StatelessWidget {
  const HomeTitleBlock({
    required this.day,
    required this.locale,
    required this.status,
    required this.loading,
    required this.offline,
    super.key,
  });

  final DateTime day;
  final String locale;
  final HomeDayStatus status;
  final bool loading;
  final bool offline;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final date = toBeginningOfSentenceCase(
      DateFormat('d MMMM', locale).format(day),
    );

    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        10,
        NinjaMetrics.screenPadding,
        14,
      ),
      child: loading
          ? const _TitleSkeleton()
          : Column(
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              children: [
                Text(
                  date,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style:
                      (textScale >= 1.6 ? NinjaText.title : NinjaText.display)
                          .copyWith(color: colors.ink),
                ),
                const SizedBox(height: 5),
                Text(
                  _statusLine(context),
                  maxLines: textScale >= 1.6 ? 2 : 1,
                  overflow: .ellipsis,
                  style: NinjaText.subtext.copyWith(color: colors.mutedDark),
                ),
              ],
            ),
    );
  }

  String _statusLine(BuildContext context) {
    final l10n = context.l10n;
    final startsAt = status.startsAt;
    final detail = switch (status.kind) {
      HomeDayStatusKind.free || HomeDayStatusKind.done => null,
      HomeDayStatusKind.live => l10n.homeOngoingShort,
      HomeDayStatusKind.upcoming => l10n.homeInMinutes(status.minutes),
      HomeDayStatusKind.scheduled =>
        startsAt == null
            ? null
            : '${l10n.start.toLowerCase()} ${DateFormat.Hm().format(startsAt)}',
    };
    return [
      if (offline) l10n.offline,
      l10n.lessonsCount(status.lessonCount),
      ?detail,
    ].join(' · ');
  }
}
