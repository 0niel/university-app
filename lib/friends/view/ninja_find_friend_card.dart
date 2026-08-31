import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';

class NinjaFindFriendCard extends StatelessWidget {
  const NinjaFindFriendCard({
    required this.name,
    required this.subtitle,
    required this.trailing,
    this.selected = false,
    super.key,
  });

  final String name;
  final String subtitle;
  final Widget trailing;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Semantics(
      selected: selected,
      child: Padding(
        padding: const .fromLTRB(
          NinjaMetrics.screenPadding,
          0,
          NinjaMetrics.screenPadding,
          10,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? colors.surfaceAlt : colors.surface,
            borderRadius: .circular(NinjaRadius.card),
          ),
          child: Padding(
            padding: const .all(16),
            child: Row(
              children: [
                NinjaAvatar(initials: ninjaInitials(name)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 3,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: NinjaText.headline.copyWith(color: colors.ink),
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: NinjaText.helper.copyWith(color: colors.muted),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
