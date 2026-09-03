import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/top_discussions/top_discussions.dart';

class HomeTrendingGroup extends StatelessWidget {
  const HomeTrendingGroup({
    required this.state,
    required this.onAll,
    required this.onOpen,
    required this.onRetry,
    super.key,
  });
  final DiscourseState state;
  final VoidCallback onAll;
  final ValueChanged<DiscourseTopic> onOpen;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final topics = state.topTopics?.topics ?? const <DiscourseTopic>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionTitle(
          title: l10n.homeTrending,
          action: l10n.homeAllLower,
          onActionTap: onAll,
          bottomPadding: 14,
        ),
        if (state.status == DiscourseStatus.failure)
          AppBanner(
            message: l10n.loadingError,
            tone: AppBannerTone.warn,
            actionLabel: l10n.retry,
            onAction: onRetry,
          ),
        if (topics.isEmpty &&
            (state.status == DiscourseStatus.loading ||
                state.status == DiscourseStatus.initial))
          const AppListGroup(children: [AppSkeletonRow(), AppSkeletonRow()])
        else if (topics.isEmpty && state.status != DiscourseStatus.failure)
          AppEmptyState.compact(title: l10n.homeTrendingEmpty)
        else if (topics.isNotEmpty)
          AppListGroup(
            children: [
              for (final topic in topics.take(2))
                _HomeTrendingRow(
                  title: topic.title,
                  subtitle: l10n.homeRepliesCount(topic.replyCount),
                  onTap: () => onOpen(topic),
                ),
            ],
          ),
      ],
    );
  }
}

class _HomeTrendingRow extends StatelessWidget {
  const _HomeTrendingRow({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppPressable(
    onTap: onTap,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppText.sans(
                      14.5,
                      FontWeight.w600,
                    ).copyWith(color: context.colors.ink),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: AppText.sans(
                      12.5,
                      FontWeight.w400,
                    ).copyWith(color: context.colors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AppLineIconWidget(
              AppLineIcon.chevronR,
              size: 16,
              color: context.colors.muted2,
            ),
          ],
        ),
      ),
    ),
  );
}
