import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/home/cubit/home_gamification_cubit.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/home/view/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/notifications/notifications.dart';
import 'package:schedule_repository/schedule_repository.dart';

class HomeDashboardTopRow extends StatelessWidget {
  const HomeDashboardTopRow({
    required this.userName,
    required this.now,
    required this.kind,
    required this.searchKey,
    required this.changes,
    super.key,
  });

  final String userName;
  final DateTime now;
  final HomeHeroKind kind;
  final GlobalKey searchKey;
  final List<ScheduleChange> changes;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final photo = context.select<AppBloc, String?>(
      (bloc) => bloc.state.user.photo,
    );
    final level = context.select<HomeGamificationCubit, int?>((cubit) {
      final profile = cubit.state;
      return profile?.isEmpty == false ? profile?.level : null;
    });
    final unreadCount = context.select<NotificationsCubit, int>((cubit) {
      final notifications = buildNotificationFeed(
        l10n: l10n,
        pushes: cubit.state.pushes,
        changes: changes,
      );
      return cubit.state.unreadCount(notifications.map((item) => item.id));
    });
    return HomeTopRow(
      userName: userName,
      photoUrl: photo,
      level: level,
      now: now,
      dotColor: switch (kind) {
        HomeHeroKind.during => colors.accent,
        HomeHeroKind.pause => colors.lecture,
        HomeHeroKind.before ||
        HomeHeroKind.done ||
        HomeHeroKind.other ||
        HomeHeroKind.free => colors.muted2,
      },
      searchKey: searchKey,
      unreadCount: unreadCount,
    );
  }
}
