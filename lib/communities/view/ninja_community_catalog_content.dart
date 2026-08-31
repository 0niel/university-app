import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/communities/communities.dart';

class NinjaCommunityCatalogContent extends StatelessWidget {
  const NinjaCommunityCatalogContent({
    required this.state,
    super.key,
    this.onReset,
  });

  final CommunityCatalogState state;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final scale = Theme.of(context).scale;
    final sections = state.visibleSections;
    final suggestionUri = safeCommunityUri(state.catalog?.suggestionUrl);
    if (sections.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const .only(top: 32),
          child: NinjaCommunityCatalogEmpty(onReset: onReset),
        ),
      );
    }
    return SliverMainAxisGroup(
      slivers: [
        for (final section in sections) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const .fromLTRB(
                NinjaMetrics.screenPadding,
                28,
                NinjaMetrics.screenPadding,
                4,
              ),
              child: Text(
                section.title,
                maxLines: 1,
                overflow: .ellipsis,
                style: NinjaText.title.copyWith(color: context.ninja.ink),
              ),
            ),
          ),
          SliverList.builder(
            itemCount: section.items.length,
            itemBuilder: (context, index) {
              final entry = section.items[index];
              return NinjaCommunityCard(entry: entry).animateListItem(
                key: ValueKey(entry.id),
                index: index,
              );
            },
          ),
        ],
        if (suggestionUri != null)
          SliverPadding(
            padding: const .only(top: 12),
            sliver: SliverToBoxAdapter(
              child: NinjaCommunitySuggestionCard(uri: suggestionUri),
            ),
          ),
        SliverToBoxAdapter(child: SizedBox(height: scale.space(24))),
      ],
    );
  }
}
