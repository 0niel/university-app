import 'package:app_ui/app_ui.dart';
import 'package:community_catalog_repository/community_catalog_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/communities/communities.dart';
import 'package:rtu_mirea_app/communities/widgets/community_catalog_skeleton.dart';
import 'package:rtu_mirea_app/communities/widgets/saved_community_row.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CommunityCatalogContent extends StatelessWidget {
  const CommunityCatalogContent({
    required this.state,
    required this.onRetry,
    required this.onReset,
    required this.onOpen,
    super.key,
  });

  final CommunityCatalogState state;
  final VoidCallback onRetry;
  final VoidCallback onReset;
  final void Function(CommunityCatalogEntry entry, String category) onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (state.catalog == null) {
      if (state.status == .failure) {
        return NinjaErrorState(
          title: l10n.loadingError,
          message: l10n.tryAgain,
          retryLabel: l10n.retry,
          onRetry: onRetry,
        );
      }
      return const CommunityCatalogSkeleton();
    }
    final sections = state.visibleSections;
    if (sections.isEmpty) {
      return NinjaEmptyState(
        title: l10n.communitiesNotFound,
        message: l10n.communitiesTryFilters,
        actionLabel: state.query.isNotEmpty || state.selectedSectionKey != null
            ? l10n.communitiesAll
            : null,
        onAction: onReset,
      );
    }
    final saved = context.watch<JoinedCommunitiesCubit>();
    final mine = [
      for (final section in state.catalog!.sections)
        for (final item in section.items)
          if (saved.isJoined(item.id)) (item, section.title),
    ];
    final unfiltered =
        state.query.trim().isEmpty && state.selectedSectionKey == null;
    final recommendations = [
      for (final section in sections)
        for (final item in section.items)
          if (!unfiltered || !saved.isJoined(item.id)) (item, section.title),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.isRefreshing) const AppProgressBar(value: 1, height: 2),
        AppOverline(l10n.communitiesMine, topPadding: 24, bottomPadding: 12),
        if (mine.isEmpty)
          AppEmptyState.compact(title: l10n.communitiesSavedEmpty)
        else
          AppListGroup(
            children: [
              for (final (entry, category) in mine)
                SavedCommunityRow(
                  entry: entry,
                  categoryTitle: category,
                  onTap: () => onOpen(entry, category),
                ),
            ],
          ),
        if (recommendations.isNotEmpty)
          AppOverline(
            state.selectedSectionKey == null
                ? l10n.communitiesRecommended
                : sections.first.title,
            topPadding: 24,
            bottomPadding: 12,
          ),
        for (final (entry, category) in recommendations) ...[
          CommunityCard(
            entry: entry,
            categoryTitle: category,
            joined: saved.isJoined(entry.id),
            onOpen: () => onOpen(entry, category),
            onToggleJoin: () => saved.toggle(entry.id),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
