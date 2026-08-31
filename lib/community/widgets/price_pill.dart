import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class PricePill extends StatelessWidget {
  const PricePill({
    super.key,
    this.shurikens,
    this.text,
    this.free = false,
    this.locked = false,
  });

  final int? shurikens;
  final String? text;
  final bool free;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final freeBackground = Color.alphaBlend(
      colors.successTint,
      colors.canvas,
    );
    final (bg, fg) = switch ((locked, free)) {
      (true, _) => (colors.surface, colors.muted),
      (_, true) => (
        freeBackground,
        colors.contrastForeground(freeBackground),
      ),
      _ => (colors.surfaceAlt, colors.ink),
    };
    return Container(
      padding: const .symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: .circular(NinjaRadius.pill),
      ),
      child: Wrap(
        spacing: 4,
        runSpacing: 2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (locked)
            AppLineIconWidget(.lock, size: 11, color: fg)
          else if (shurikens != null && !free)
            AppNinjaMark(size: 12, color: fg),
          Text(
            free
                ? (text ?? context.l10n.priceFree)
                : (text ?? shurikens?.toString() ?? '—'),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: NinjaText.tabular(
              NinjaText.badge.copyWith(color: fg),
            ),
          ),
        ],
      ),
    );
  }
}
