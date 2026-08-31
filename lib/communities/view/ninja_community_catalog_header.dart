import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NinjaCommunityCatalogHeader extends StatelessWidget {
  const NinjaCommunityCatalogHeader({
    required this.searchController,
    required this.onChanged,
    super.key,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final scale = Theme.of(context).scale;
    return Padding(
      padding: .fromLTRB(
        scale.space(NinjaMetrics.screenPadding),
        scale.space(8),
        scale.space(NinjaMetrics.screenPadding),
        scale.space(12),
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            children: [
              NinjaIconButton(
                icon: const AppLineIconWidget(AppLineIcon.chevronL, size: 20),
                tooltip: context.l10n.back,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
          SizedBox(height: scale.space(12)),
          Text(
            context.l10n.communitiesTitle,
            style:
                (MediaQuery.textScalerOf(context).scale(1) >= 1.6
                        ? NinjaText.title
                        : NinjaText.display)
                    .copyWith(color: colors.ink),
          ),
          SizedBox(height: scale.space(5)),
          Text(
            context.l10n.communitiesSubtitle,
            style: NinjaText.subtext.copyWith(color: colors.mutedDark),
          ),
          SizedBox(height: scale.space(18)),
          Hero(
            tag: 'community-search',
            child: Material(
              color: Colors.transparent,
              child: NinjaInput(
                controller: searchController,
                placeholder: context.l10n.communitiesSearchHintInline,
                leadingIcon: AppLineIconWidget(
                  .search,
                  size: 18,
                  color: colors.muted,
                ),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
