import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
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
    required this.onDownload,
    required this.onRetry,
    required this.onUpload,
    required this.onResetFilter,
    super.key,
  });

  final bool isLoading;
  final bool isFailure;
  final bool isFiltered;
  final List<StudyMaterial> materials;
  final List<MaterialAuthor> authors;
  final ValueChanged<StudyMaterial> onDownload;
  final VoidCallback onRetry;
  final VoidCallback onUpload;
  final VoidCallback onResetFilter;

  @override
  Widget build(BuildContext context) {
    return NinjaStateSwitcher(child: _body(context));
  }

  Widget _body(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    if (isLoading) {
      return ListView(
        key: const ValueKey('knowledge-loading'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        children: const [KnowledgeBankListSkeleton()],
      );
    }
    if (isFailure) {
      return ListView(
        key: const ValueKey('knowledge-failure'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
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
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 100),
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
    final itemCount = materials.length + (authors.isEmpty ? 0 : 2);
    return ListView.separated(
      key: const ValueKey('knowledge-ready'),
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
      itemCount: itemCount,
      separatorBuilder: (_, index) => SizedBox(
        height: index == materials.length - 1 ? 28 : 10,
      ),
      itemBuilder: (context, index) {
        final material = materials.elementAtOrNull(index);
        if (material != null) {
          return MaterialRow(
            key: ValueKey(material.id),
            material: material,
            onDownload: () => onDownload(material),
          ).animateListItem(index: index);
        }
        if (index == materials.length) {
          return Text(
            l10n.knowledgeTopAuthors,
            style: NinjaText.title.copyWith(color: colors.ink),
          );
        }
        return TopAuthorsCard(authors: authors);
      },
    );
  }
}
