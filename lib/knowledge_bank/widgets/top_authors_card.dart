import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class TopAuthorsCard extends StatelessWidget {
  const TopAuthorsCard({required this.authors, super.key});

  final List<MaterialAuthor> authors;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xsm,
      ),
      child: Column(
        children: [
          for (final (index, author) in authors.indexed)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.gap),
              child: Row(
                children: [
                  SizedBox(
                    width: 18,
                    child: Text(
                      '${index + 1}',
                      style: AppText.tabular(
                        AppText.body.copyWith(
                          fontWeight: FontWeight.w700,
                          color: index == 0 ? colors.accent : colors.muted,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppAvatar(name: author.name),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      author.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body.copyWith(
                        color: colors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.gap),
                  AppRowTrailing(
                    child: Text(
                      l10n.knowledgeAuthorStats(
                        author.downloads,
                        author.materials,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.subtext.copyWith(color: colors.muted),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
