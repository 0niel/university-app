import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/home/view/home_deadline_row.dart';
import 'package:rtu_mirea_app/home/view/home_deadlines_skeleton.dart';
import 'package:rtu_mirea_app/home/view/home_empty_row.dart';
import 'package:rtu_mirea_app/home/view/home_error_row.dart';
import 'package:rtu_mirea_app/home/view/home_section_header.dart';
import 'package:rtu_mirea_app/home/view/home_section_list.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

class HomeDeadlinesSection extends StatelessWidget {
  const HomeDeadlinesSection({
    required this.deadlines,
    required this.loading,
    required this.failed,
    required this.onReload,
    super.key,
  });

  final List<Deadline> deadlines;
  final bool loading;
  final bool failed;
  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        HomeSectionHeader(
          title: l10n.homeDeadlines,
          action: deadlines.isEmpty
              ? l10n.homeCreateArrow
              : l10n.all.toLowerCase(),
          onAction: () => context.go('/services/deadlines'),
        ),
        NinjaStateSwitcher(child: _content(context)),
      ],
    );
  }

  Widget _content(BuildContext context) {
    if (loading) {
      return const HomeSectionList(
        key: ValueKey('home-deadlines-loading'),
        children: [HomeDeadlinesSkeleton()],
      );
    }
    if (failed) {
      return HomeErrorRow(
        key: const ValueKey('home-deadlines-failed'),
        onRetry: onReload,
      );
    }
    if (deadlines.isEmpty) {
      return HomeSectionList(
        key: const ValueKey('home-deadlines-empty'),
        children: [
          HomeEmptyRow(
            text: context.l10n.homeNoDeadlines,
            onTap: () => context.go('/services/deadlines'),
          ),
        ],
      );
    }
    return HomeSectionList(
      key: const ValueKey('home-deadlines'),
      children: [
        for (final (index, deadline) in deadlines.take(2).indexed)
          HomeDeadlineRow(
            deadline: deadline,
            onToggled: onReload,
          ).animateListItem(index: index),
      ],
    );
  }
}
