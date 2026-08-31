import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/search/search.dart';
import 'package:rtu_mirea_app/tour/tour.dart';

part 'header_circle_button.dart';
part 'identity_skeleton.dart';

class HomeDashboardHeader extends StatelessWidget {
  const HomeDashboardHeader({
    required this.day,
    required this.locale,
    required this.userName,
    required this.greeting,
    required this.loading,
    required this.searchKey,
    super.key,
  });

  final DateTime day;
  final String locale;
  final String userName;
  final String greeting;
  final bool loading;
  final GlobalKey searchKey;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final toolbarHeight = textScale >= 1.6 ? 84.0 : 64.0;
    final dateLine = toBeginningOfSentenceCase(
      DateFormat('EEEE, d MMMM', locale).format(day),
    );

    return SliverAppBar(
      pinned: true,
      toolbarHeight: toolbarHeight,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: colors.canvas.withValues(alpha: 0.96),
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      titleSpacing: NinjaMetrics.screenPadding,
      title: Row(
        children: [
          AppPressable(
            onTap: () => context.go('/profile'),
            semanticsLabel: userName,
            child: NinjaAvatar(
              initials: _initialsOf(userName),
              size: 40,
              tone: .indigo,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: loading
                ? const _IdentitySkeleton()
                : Column(
                    mainAxisSize: .min,
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        greeting,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: NinjaText.headline.copyWith(color: colors.ink),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dateLine,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: NinjaText.helper.copyWith(
                          color: colors.mutedDark,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      actions: [
        AppTourAnchor(
          target: .homeSearch,
          child: _HeaderCircleButton(
            buttonKey: searchKey,
            icon: .search,
            label: l10n.searchGlobalHint,
            onTap: () => openGlobalSearch(context),
          ),
        ),
        const SizedBox(width: 8),
        _HeaderCircleButton(
          icon: .bell,
          label: l10n.notifications,
          onTap: () => context.go('/profile/settings/notifications'),
        ),
        const SizedBox(width: NinjaMetrics.screenPadding),
      ],
    );
  }
}

String _initialsOf(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  final letters = parts.take(2).map((part) => part[0].toUpperCase());
  return letters.isEmpty ? '?' : letters.join();
}
