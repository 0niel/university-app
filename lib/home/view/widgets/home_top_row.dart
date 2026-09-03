import 'package:academic_calendar/academic_calendar.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/notifications/notifications.dart';
import 'package:rtu_mirea_app/search/search.dart';
import 'package:rtu_mirea_app/tour/tour.dart';

class HomeTopRow extends StatelessWidget {
  const HomeTopRow({
    required this.userName,
    required this.now,
    required this.dotColor,
    required this.searchKey,
    super.key,
    this.photoUrl,
    this.level,
    this.unreadCount = 0,
  });

  final String userName;
  final DateTime now;
  final Color dotColor;
  final GlobalKey searchKey;
  final String? photoUrl;
  final int? level;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final clock = HomeClockPill(now: now, dotColor: dotColor);
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact =
            constraints.maxWidth <
            3 * AppControlSize.touchTarget +
                3 * AppSpacing.sm +
                clock.minimumWidth(context);
        final row = Row(
          children: [
            AppPressable(
              onTap: () => const ProfileRoute().go(context),
              semanticsLabel: userName,
              child: SizedBox.square(
                dimension: AppControlSize.touchTarget,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AppAvatar(
                        name: userName,
                        size: 42,
                        color: context.colors.accent,
                        imageUrl: photoUrl,
                      ),
                      if (level != null)
                        Positioned(
                          right: -3,
                          bottom: -3,
                          child: Container(
                            width: 18,
                            height: 18,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: context.colors.accent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: context.colors.canvas,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              '$level',
                              style: AppText.sans(
                                9,
                                FontWeight.w800,
                                height: 1,
                              ).copyWith(color: context.colors.onAccent),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            if (compact)
              const Spacer()
            else
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0, -1),
                  child: Center(child: clock),
                ),
              ),
            const SizedBox(width: AppSpacing.sm),
            AppTourAnchor(
              target: .homeSearch,
              child: KeyedSubtree(
                key: searchKey,
                child: AppHeaderCircleButton(
                  visualAlignment: Alignment.topRight,
                  action: AppHeaderAction(
                    icon: .search,
                    onTap: () => openGlobalSearch(context),
                    semanticsLabel: l10n.homeSearchLabel,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Stack(
              clipBehavior: Clip.none,
              children: [
                AppHeaderCircleButton(
                  visualAlignment: Alignment.topRight,
                  action: AppHeaderAction(
                    icon: AppLineIcon.bell,
                    onTap: () => showNotificationsSheet(context),
                    semanticsLabel: l10n.notifications,
                  ),
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: IgnorePointer(
                      child: Container(
                        height: 18,
                        constraints: const BoxConstraints(minWidth: 18),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: context.colors.danger,
                          borderRadius: BorderRadius.circular(
                            AppRadius.skeleton,
                          ),
                          border: Border.all(
                            color: context.colors.canvas,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          unreadCount > 99 ? '99+' : '$unreadCount',
                          style: AppText.sans(
                            10,
                            FontWeight.w800,
                            height: 1.2,
                          ).copyWith(color: context.colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
        if (!compact) return row;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            row,
            const SizedBox(height: 12),
            Align(child: clock),
          ],
        );
      },
    );
  }
}

class HomeClockPill extends StatelessWidget {
  const HomeClockPill({
    required this.now,
    required this.dotColor,
    super.key,
  });

  final DateTime now;
  final Color dotColor;

  double minimumWidth(BuildContext context) {
    final l10n = context.l10n;
    final parity = getWeek(now).isOdd
        ? l10n.weekParityOddFull
        : l10n.weekParityEvenFull;
    double measure(String text, FontWeight weight) {
      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: AppText.sans(13, weight, tabular: true),
        ),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
      )..layout();
      final width = painter.width;
      painter.dispose();
      return width;
    }

    return AppSpacing.gap +
        AppSpacing.md +
        3 * AppSpacing.sm +
        measure(DateFormat.Hm().format(now), FontWeight.w700) +
        measure(l10n.homeWeekParity(parity), FontWeight.w500);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final week = getWeek(now);
    final parity = week.isOdd
        ? l10n.weekParityOddFull
        : l10n.weekParityEvenFull;
    return Container(
      constraints: const BoxConstraints(minHeight: 34),
      padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
          AppDot(size: 8, color: dotColor),
          const SizedBox(width: 8),
          Text(
            DateFormat.Hm().format(now),
            style: AppText.sans(13, FontWeight.w700, tabular: true).copyWith(
              color: colors.ink,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            l10n.homeWeekParity(parity),
            style: AppText.sans(13, FontWeight.w500).copyWith(
              color: colors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
