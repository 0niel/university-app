import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MapLoadingPill extends StatelessWidget {
  const MapLoadingPill({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final label = context.l10n.mapOpeningFloor;
    return Semantics(
      liveRegion: true,
      label: label,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.pill),
        ),
        child: Padding(
          padding: const .symmetric(horizontal: 16, vertical: 11),
          child: Row(
            mainAxisSize: .min,
            children: [
              NinjaSpinner(size: 16, strokeWidth: 2, color: colors.ink),
              const SizedBox(width: 9),
              Text(
                label,
                style: NinjaText.microLabel.copyWith(color: colors.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
