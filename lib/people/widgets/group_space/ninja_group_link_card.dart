import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NinjaGroupLinkCard extends StatelessWidget {
  const NinjaGroupLinkCard({
    required this.link,
    required this.onOpen,
    this.pending = false,
    this.onDelete,
    super.key,
  });

  final GroupLink link;
  final VoidCallback onOpen;
  final bool pending;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final row = AnimatedOpacity(
      opacity: pending ? 0.5 : 1,
      duration: const Duration(milliseconds: 160),
      child: Padding(
        padding: const .fromLTRB(
          NinjaMetrics.screenPadding,
          0,
          NinjaMetrics.screenPadding,
          8,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: .circular(NinjaRadius.card),
          ),
          child: NinjaListCell(
            title: link.title,
            subtitle: context.l10n.groupSpaceLinkAddedBy(link.addedBy),
            showDivider: false,
            onTap: onOpen,
          ),
        ),
      ),
    );
    final onDelete = this.onDelete;
    if (onDelete == null) return row;
    return Dismissible(
      key: ValueKey(link.id),
      direction: .endToStart,
      background: ColoredBox(
        color: colors.scarlet,
        child: Align(
          alignment: .centerRight,
          child: Padding(
            padding: const .symmetric(
              horizontal: NinjaMetrics.screenPadding,
            ),
            child: NinjaGlyphIcon(
              NinjaGlyph.trash,
              size: 18,
              color: colors.ninjaOnScarlet,
            ),
          ),
        ),
      ),
      confirmDismiss: (_) async {
        if (!pending) onDelete();
        return false;
      },
      child: row,
    );
  }
}
