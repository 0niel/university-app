import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NfcPassHeader extends StatelessWidget {
  const NfcPassHeader({
    required this.title,
    super.key,
    this.statusLabel,
    this.onBack,
    this.backTooltip,
    this.onSettings,
    this.settingsTooltip,
  });

  final String title;
  final String? statusLabel;
  final VoidCallback? onBack;
  final String? backTooltip;
  final VoidCallback? onSettings;
  final String? settingsTooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final status = statusLabel;
    final settings = onSettings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            NinjaMetrics.screenPadding,
            6,
            NinjaMetrics.screenPadding,
            0,
          ),
          child: Row(
            children: [
              if (onBack != null)
                NinjaIconButton(
                  icon: NinjaGlyphIcon(
                    NinjaGlyph.arrowLeft,
                    size: 20,
                    color: colors.ink,
                  ),
                  tooltip: backTooltip,
                  onPressed: onBack,
                ),
              const Spacer(),
              if (settings != null)
                NinjaIconButton(
                  icon: AppLineIconWidget(
                    AppLineIcon.tune,
                    size: 20,
                    color: colors.ink,
                  ),
                  tooltip: settingsTooltip,
                  onPressed: settings,
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            NinjaMetrics.screenPadding,
            8,
            NinjaMetrics.screenPadding,
            0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: NinjaText.display.copyWith(color: colors.ink),
                ),
              ),
              if (status != null) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: colors.brandTint,
                    borderRadius: BorderRadius.circular(NinjaRadius.pill),
                  ),
                  child: Text(
                    status,
                    style: NinjaText.badge.copyWith(color: colors.brandInk),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
