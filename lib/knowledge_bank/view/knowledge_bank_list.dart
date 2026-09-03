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
    required this.onDownload,
    required this.onRetry,
    required this.onUpload,
    required this.onResetFilter,
    this.footer,
    super.key,
  });

  final bool isLoading;
  final bool isFailure;
  final bool isFiltered;
  final List<StudyMaterial> materials;
  final List<MaterialAuthor> authors;
  final Set<String> openingMaterialIds;
  final ValueChanged<StudyMaterial> onDownload;
  final VoidCallback onRetry;
  final VoidCallback onUpload;
  final VoidCallback onResetFilter;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return NinjaStateSwitcher(child: _body(context));
  }

  Widget _body(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    if (isLoading) {
      return ListView(
        key: const ValueKey('knowledge-loading'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.sm,
          AppSpacing.screen,
          110,
        ),
        children: const [KnowledgeBankListSkeleton()],
      );
    }
    if (isFailure) {
      return ListView(
        key: const ValueKey('knowledge-failure'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.xlg,
          AppSpacing.screen,
          100,
        ),
        children: [
          NinjaErrorState(
            title: l10n.loadingError,
            message: l10n.tryAgain,
            retryLabel: l10n.retry,
            onRetry: onRetry,
          ).animateEmptyState(),
        ],
      );
    }
    if (materials.isEmpty) {
      return ListView(
        key: ValueKey(isFiltered ? 'knowledge-filtered' : 'knowledge-empty'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.xxl,
          AppSpacing.screen,
          100,
        ),
        children: [
          if (isFiltered)
            NinjaEmptyState(
              icon: const AppLineIconWidget(AppLineIcon.filter),
              title: l10n.searchNoResults,
              message: l10n.searchNoResultsHint,
              actionLabel: l10n.resetFilter,
              onAction: onResetFilter,
              outlinedAction: true,
            ).animateEmptyState()
          else
            NinjaEmptyState(
              icon: const AppLineIconWidget(AppLineIcon.book),
              title: l10n.knowledgeEmptyTitle,
              message: l10n.knowledgeEmptySub,
              actionLabel: l10n.knowledgeUpload,
              onAction: onUpload,
            ).animateEmptyState(),
        ],
      );
    }
    return ListView(
      key: const ValueKey('knowledge-ready'),
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.zero,
        AppSpacing.screen,
        AppSpacing.xxlg,
      ),
      children: [
        AppListGroup(
          children: [
            for (final material in materials)
              MaterialRow(
                key: ValueKey(material.id),
                material: material,
                loading: openingMaterialIds.contains(material.id),
                onDownload: () => onDownload(material),
              ),
          ],
        ),
        if (authors.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sheetBottom),
          Text(
            l10n.knowledgeTopAuthors,
            style: AppText.title.copyWith(color: colors.ink),
          ),
          const SizedBox(height: AppSpacing.gap),
          TopAuthorsCard(authors: authors),
        ],
        if (footer != null) ...[
          const SizedBox(height: AppSpacing.screen),
          footer!,
        ],
      ],
    );
  }
}
