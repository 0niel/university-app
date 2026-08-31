import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/widgets/map_action_button.dart';

class MapTopBar extends StatelessWidget {
  const MapTopBar({required this.onSearch, super.key});

  final VoidCallback? onSearch;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final searchHeight = (52 + (textScale - 1).clamp(0, 1) * 18).toDouble();
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const .fromLTRB(
          NinjaMetrics.screenPadding,
          8,
          NinjaMetrics.screenPadding,
          0,
        ),
        child: Row(
          children: [
            if (Navigator.of(context).canPop()) ...[
              MapActionButton(
                tooltip: l10n.back,
                icon: .chevronL,
                onTap: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: AppPressable(
                onTap: onSearch,
                semanticsLabel: l10n.mapFindRoom,
                semanticsButton: true,
                child: Container(
                  height: searchHeight,
                  padding: const .symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: .circular(NinjaRadius.pill),
                  ),
                  child: Row(
                    children: [
                      AppLineIconWidget(
                        .search,
                        size: 20,
                        color: colors.mutedDark,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.mapFindRoom,
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: NinjaText.body.copyWith(
                            color: colors.mutedDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
