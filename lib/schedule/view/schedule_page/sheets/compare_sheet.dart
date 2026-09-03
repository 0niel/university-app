import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:schedule_repository/schedule_repository.dart';

Future<void> showCompareSheet(BuildContext context) {
  return showAppSheet<void>(
    context,
    title: context.l10n.scheduleCompareTitle,
    subtitle: context.l10n.scheduleCompareSubtitle,
    child: _CompareFriends(
      friends: context.read<FriendsRepository>(),
      repository: context.read<ScheduleRepository>(),
      comparison: context.read<ScheduleComparisonCubit>(),
    ),
  );
}

class _CompareFriends extends StatefulWidget {
  const _CompareFriends({
    required this.friends,
    required this.repository,
    required this.comparison,
  });
  final FriendsRepository friends;
  final ScheduleRepository repository;
  final ScheduleComparisonCubit comparison;
  @override
  State<_CompareFriends> createState() => _CompareFriendsState();
}

class _CompareFriendsState extends State<_CompareFriends> {
  late Future<List<Friend>> _friends = widget.friends.getFriends();
  String? _busy;
  String? _error;

  Future<void> _choose(Friend friend) async {
    setState(() {
      _busy = friend.userId;
      _error = null;
    });
    try {
      final response = await widget.repository.getSchedule(
        group: friend.group!,
      );
      if (!mounted) return;
      widget.comparison.start(
        SelectedGroupSchedule(
          group: Group(name: friend.group!),
          schedule: response.data,
        ),
        friendName: friend.fullName,
      );
      ToastManager.showSuccess(
        context,
        message: context.l10n.scheduleCompareStarted(friend.fullName),
      );
      Navigator.of(context).pop();
    } on Exception {
      if (mounted) setState(() => _error = context.l10n.compareLoadError);
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Friend>>(
    future: _friends,
    builder: (context, snapshot) {
      final l10n = context.l10n;
      if (snapshot.hasError) {
        return AppErrorState(
          title: l10n.compareLoadError,
          message: null,
          footnote: null,
          primaryLabel: l10n.retry,
          onPrimary: () =>
              setState(() => _friends = widget.friends.getFriends()),
        );
      }
      if (!snapshot.hasData) {
        return const AppSkeletonGroup(
          child: Column(children: [AppSkeletonRow(), AppSkeletonRow()]),
        );
      }
      final friends = snapshot.data!
          .where((f) => f.group?.trim().isNotEmpty ?? false)
          .toList();
      if (friends.isEmpty) {
        return AppEmptyState(
          title: l10n.scheduleCompareNoFriends,
          subtitle: l10n.scheduleCompareNoFriendsHint,
        );
      }
      return Column(
        children: [
          if (_error != null)
            AppBanner(message: _error!, tone: AppBannerTone.danger),
          AppListGroup(
            children: [
              for (final friend in friends)
                AppListRow(
                  title: friend.fullName,
                  subtitle: friend.group,
                  leading: AppAvatar(name: friend.fullName, size: 40),
                  strong: true,
                  trailing: _busy == friend.userId
                      ? const AppSpinner(size: 20)
                      : null,
                  onTap: _busy == null ? () => _choose(friend) : null,
                ),
            ],
          ),
        ],
      );
    },
  );
}
