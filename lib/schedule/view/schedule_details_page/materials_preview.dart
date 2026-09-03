part of '../schedule_details_page.dart';

class _MaterialsPreview extends StatelessWidget {
  const _MaterialsPreview({
    required this.loading,
    required this.error,
    required this.materials,
    required this.onRetry,
    required this.onOpenAll,
    required this.onUpload,
  });

  final bool loading;
  final Object? error;
  final List<LessonMaterial> materials;
  final VoidCallback onRetry;
  final VoidCallback onOpenAll;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        _SectionTitle(
          title: l10n.lessonDetailsMaterials,
          action: l10n.lessonMaterialsAdd,
          onAction: onUpload,
        ),
        AppStateSwitcher(child: _buildState(l10n)),
      ],
    );
  }

  Widget _buildState(AppLocalizations l10n) {
    const inset = EdgeInsets.fromLTRB(
      AppSpacing.screen,
      AppSpacing.zero,
      AppSpacing.screen,
      AppSpacing.lg,
    );

    if (loading) {
      return const _MaterialsPreviewSkeleton(
        key: ValueKey('materials_preview_skeleton'),
      );
    }
    if (error != null) {
      return Padding(
        key: const ValueKey('materials_preview_error'),
        padding: inset,
        child: AppErrorState(
          title: l10n.lessonDetailsLoadFailed,
          message: l10n.lessonDetailsCheckConnection,
          primaryLabel: l10n.lessonDetailsTapRetry,
          footnote: null,
          onPrimary: onRetry,
        ),
      );
    }
    if (materials.isEmpty) {
      return Padding(
        padding: inset,
        child: SizedBox(
          width: double.infinity,
          child: AppEmptyState(
            title: l10n.lessonDetailsNoMaterialsYet,
            subtitle: l10n.lessonDetailsUploadHint,
            actionLabel: l10n.lessonDetailsUpload,
            onAction: onUpload,
          ),
        ),
      ).animateEmptyState(key: const ValueKey('materials_preview_empty'));
    }
    return Padding(
      key: const ValueKey('materials_preview_list'),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screen,
      ),
      child: AppListGroup(
        children: [
          for (final (index, material) in materials.take(4).indexed)
            _MaterialInlineRow(
              material: material,
              onTap: onOpenAll,
            ).animateListItem(index: index),
        ],
      ),
    );
  }
}
