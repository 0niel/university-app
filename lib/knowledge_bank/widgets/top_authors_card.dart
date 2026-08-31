import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class TopAuthorsCard extends StatelessWidget {
  const TopAuthorsCard({required this.authors, super.key});

  final List<MaterialAuthor> authors;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          children: [
            for (final (index, author) in authors.indexed)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: index == 0
                          ? colors.brandTint
                          : colors.surfaceAlt,
                      child: Text(
                        '${index + 1}',
                        style: NinjaText.tabular(
                          NinjaText.body.copyWith(
                            fontWeight: FontWeight.w700,
                            color: index == 0 ? colors.brandInk : colors.muted,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        author.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: NinjaText.body.copyWith(
                          color: colors.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    AppRowTrailing(
                      child: Text(
                        l10n.knowledgeAuthorStats(
                          author.downloads,
                          author.materials,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: NinjaText.subtext.copyWith(color: colors.muted),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
