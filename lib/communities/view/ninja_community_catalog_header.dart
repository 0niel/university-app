import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/communities/view/ninja_community_section_filters.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NinjaCommunityCatalogHeader extends StatelessWidget {
  const NinjaCommunityCatalogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final scale = Theme.of(context).scale;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final toolbarHeight = scale.space(56);
    final expandedHeight = scale.space(textScale >= 1.6 ? 260 : 210);
    return SliverAppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: toolbarHeight,
      expandedHeight: expandedHeight,
      backgroundColor: colors.canvas,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: scale.space(60),
      leading: Center(
        child: NinjaIconButton(
          icon: const AppLineIconWidget(AppLineIcon.chevronL, size: 20),
          tooltip: context.l10n.back,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Padding(
          padding: .fromLTRB(
            0,
            toolbarHeight + scale.space(12),
            0,
            scale.space(4),
          ),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Padding(
                padding: .symmetric(
                  horizontal: scale.space(NinjaMetrics.screenPadding),
                ),
                child: Text(
                  context.l10n.communitiesTitle,
                  maxLines: textScale >= 1.6 ? 2 : 1,
                  overflow: .ellipsis,
                  style:
                      (textScale >= 1.6 ? NinjaText.title : NinjaText.display)
                          .copyWith(color: colors.ink),
                ),
              ),
              SizedBox(height: scale.space(5)),
              Padding(
                padding: .symmetric(
                  horizontal: scale.space(NinjaMetrics.screenPadding),
                ),
                child: Text(
                  context.l10n.communitiesSubtitle,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: NinjaText.subtext.copyWith(color: colors.mutedDark),
                ),
              ),
              const Spacer(),
              const NinjaCommunitySectionFilters(),
            ],
          ),
        ),
      ),
    );
  }
}

class NinjaCommunityCatalogSearchHeader extends StatelessWidget {
  const NinjaCommunityCatalogSearchHeader({
    required this.searchController,
    required this.onChanged,
    super.key,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final height = 72.0 + (textScale - 1).clamp(0, 1) * 22;
    return SliverAppBar(
      pinned: true,
      primary: false,
      automaticallyImplyLeading: false,
      toolbarHeight: height,
      backgroundColor: context.ninja.canvas,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: Padding(
        padding: const .fromLTRB(
          NinjaMetrics.screenPadding,
          10,
          NinjaMetrics.screenPadding,
          8,
        ),
        child: Hero(
          tag: 'community-search',
          child: Material(
            color: Colors.transparent,
            child: NinjaInput(
              controller: searchController,
              placeholder: context.l10n.communitiesSearchHintInline,
              leadingIcon: AppLineIconWidget(
                .search,
                size: 18,
                color: context.ninja.muted,
              ),
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
