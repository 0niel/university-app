part of '../schedule_details_page.dart';

class _MaterialsPreview extends StatelessWidget {
  const _MaterialsPreview({
    required this.loading,
    required this.error,
    required this.materials,
    required this.onRetry,
    required this.onOpenAll,
  });

  final bool loading;
  final Object? error;
  final List<LessonMaterial> materials;
  final VoidCallback onRetry;
  final VoidCallback onOpenAll;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        _SectionTitle(
          title: l10n.lessonDetailsMaterials,
          action: materials.isEmpty
              ? null
              : l10n.lessonDetailsAllCount(materials.length),
          onAction: onOpenAll,
        ),
        NinjaStateSwitcher(child: _buildState(l10n)),
      ],
    );
  }

  Widget _buildState(AppLocalizations l10n) {
    const inset = EdgeInsets.fromLTRB(
      NinjaMetrics.screenPadding,
      0,
      NinjaMetrics.screenPadding,
      16,
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
        child: NinjaErrorCard(
          title: l10n.lessonDetailsLoadFailed,
          message: l10n.lessonDetailsCheckConnection,
          actionLabel: l10n.lessonDetailsTapRetry,
          onAction: onRetry,
        ),
      );
    }
    if (materials.isEmpty) {
      return Padding(
        padding: inset,
        child: SizedBox(
          width: double.infinity,
          child: NinjaEmptyState(
            title: l10n.lessonDetailsNoMaterialsYet,
            message: l10n.lessonDetailsUploadHint,
            actionLabel: l10n.lessonDetailsUpload,
            onAction: onOpenAll,
          ),
        ),
      ).animateEmptyState(key: const ValueKey('materials_preview_empty'));
    }
    return Padding(
      key: const ValueKey('materials_preview_list'),
      padding: const EdgeInsets.symmetric(
        horizontal: NinjaMetrics.screenPadding,
      ),
      child: Column(
        spacing: 10,
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
