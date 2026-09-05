import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/knowledge_bank/view/knowledge_bank_list_skeleton.dart';
import 'package:rtu_mirea_app/knowledge_bank/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class KnowledgeBankList extends StatelessWidget {
  const KnowledgeBankList({
    required this.isLoading,
    required this.isFailure,
    required this.isFiltered,
    required this.materials,
    required this.authors,
    required this.openingMaterialIds,
    required this.onOpen,
    required this.onDownload,
    required this.onRetry,
    required this.onUpload,
    required this.onResetFilter,
    this.previewUrls = const {},
    this.heroTagForMaterial,
    this.onLike,
    this.onLongPress,
    this.gridView = false,
    this.footer,
    super.key,
  });

  final bool isLoading;
  final bool isFailure;
  final bool isFiltered;
  final List<StudyMaterial> materials;
  final List<MaterialAuthor> authors;
  final Set<String> openingMaterialIds;
  final ValueChanged<StudyMaterial> onOpen;
  final ValueChanged<StudyMaterial> onDownload;
  final VoidCallback onRetry;
  final VoidCallback onUpload;
  final VoidCallback onResetFilter;
  final Map<String, String> previewUrls;
  final Object? Function(StudyMaterial)? heroTagForMaterial;
  final ValueChanged<StudyMaterial>? onLike;
  final ValueChanged<StudyMaterial>? onLongPress;
  final bool gridView;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    Widget? state;
    if (isLoading) {
      state = const KnowledgeBankListSkeleton();
    } else if (isFailure) {
      state = NinjaErrorState(
        title: l10n.loadingError,
        message: l10n.tryAgain,
        retryLabel: l10n.retry,
        onRetry: onRetry,
      ).animateEmptyState();
    } else if (materials.isEmpty) {
      state = isFiltered
          ? NinjaEmptyState(
              icon: const AppLineIconWidget(AppLineIcon.filter),
              title: l10n.searchNoResults,
              message: l10n.searchNoResultsHint,
              actionLabel: l10n.resetFilter,
              onAction: onResetFilter,
              outlinedAction: true,
            ).animateEmptyState()
          : NinjaEmptyState(
              icon: const AppLineIconWidget(AppLineIcon.book),
              title: l10n.knowledgeEmptyTitle,
              message: l10n.knowledgeEmptySub,
              actionLabel: l10n.knowledgeUpload,
              onAction: onUpload,
            ).animateEmptyState();
    }
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.zero,
        AppSpacing.screen,
        AppSpacing.xxlg + MediaQuery.paddingOf(context).bottom,
      ),
      sliver: SliverMainAxisGroup(
        slivers: [
          if (state != null)
            SliverToBoxAdapter(child: state)
          else if (gridView)
            SliverLayoutBuilder(
              builder: (context, constraints) {
                final textScale = MediaQuery.textScalerOf(context).scale(1);
                final columns =
                    (constraints.crossAxisExtent /
                            (160 * textScale.clamp(1, 1.6)))
                        .floor()
                        .clamp(1, 4);
                return SliverList.separated(
                  itemCount: (materials.length / columns).ceil(),
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, row) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var column = 0; column < columns; column++) ...[
                        if (column > 0) const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: row * columns + column < materials.length
                              ? _gridCard(materials[row * columns + column])
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ],
                  ).animateListItem(index: row),
                );
              },
            )
          else
            SliverList.separated(
              itemCount: materials.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final material = materials[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  child: MaterialRow(
                    key: ValueKey(material.id),
                    material: material,
                    heroTag: heroTagForMaterial?.call(material),
                    loading: openingMaterialIds.contains(material.id),
                    onOpen: () => onOpen(material),
                    onDownload: () => onDownload(material),
                    previewUrl: previewUrls[material.previewPath],
                    onLike: onLike == null ? null : () => onLike!(material),
                    onLongPress: onLongPress == null
                        ? null
                        : () => onLongPress!(material),
                  ),
                ).animateListItem(key: ValueKey(material.id), index: index);
              },
            ),
          if (state == null && authors.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sheetBottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.knowledgeTopAuthors,
                      style: AppText.title.copyWith(color: colors.ink),
                    ),
                    const SizedBox(height: AppSpacing.gap),
                    TopAuthorsCard(authors: authors),
                  ],
                ),
              ),
            ),
          if (footer != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.screen),
                child: footer,
              ),
            ),
        ],
      ),
    );
  }

  Widget _gridCard(StudyMaterial material) => MaterialGridCard(
    key: ValueKey(material.id),
    material: material,
    heroTag: heroTagForMaterial?.call(material),
    loading: openingMaterialIds.contains(material.id),
    onOpen: () => onOpen(material),
    onDownload: () => onDownload(material),
    previewUrl: previewUrls[material.previewPath],
    onLike: onLike == null ? null : () => onLike!(material),
    onLongPress: onLongPress == null ? null : () => onLongPress!(material),
  );
}
