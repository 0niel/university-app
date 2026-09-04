import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:promo_repository/promo_repository.dart';

class PromoFaqTile extends StatefulWidget {
  const PromoFaqTile({
    required this.item,
    super.key,
    this.isFirst = false,
  });

  final PromoFaqItem item;
  final bool isFirst;

  @override
  State<PromoFaqTile> createState() => _PromoFaqTileState();
}

class _PromoFaqTileState extends State<PromoFaqTile> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final duration = NinjaMotion.of(context);
    return AppPressable(
      onTap: () => setState(() => _expanded = !_expanded),
      semanticsLabel: widget.item.question,
      semanticsButton: true,
      semanticsToggled: _expanded,
      child: Container(
        decoration: BoxDecoration(
          border: widget.isFirst
              ? null
              : Border(top: BorderSide(color: colors.line)),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sectionGap,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.item.question,
                    style: AppText.bodyStrong.copyWith(color: colors.ink),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                AnimatedRotation(
                  turns: _expanded ? .5 : 0,
                  duration: duration,
                  child: AppLineIconWidget(
                    AppLineIcon.chevronD,
                    size: AppIconSize.sm,
                    color: colors.muted2,
                    strokeWidth: 2.5,
                  ),
                ),
              ],
            ),
            AnimatedSize(
              duration: duration,
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: _expanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Text(
                        widget.item.answer,
                        style: AppText.subtext.copyWith(color: colors.muted),
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}
