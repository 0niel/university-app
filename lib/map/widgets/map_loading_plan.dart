import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class MapLoadingPlan extends StatelessWidget {
  const MapLoadingPlan({this.label, super.key});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final label = this.label;
    final indicator = AppSpinner(size: 20, color: context.colors.muted);
    if (label == null) return Center(child: ExcludeSemantics(child: indicator));
    final textStyle = AppText.body.copyWith(color: context.colors.ink);
    final fontSize = textStyle.fontSize!;
    final textScale =
        MediaQuery.textScalerOf(context).scale(fontSize) / fontSize;
    return Semantics(
      container: true,
      liveRegion: true,
      label: label,
      child: ExcludeSemantics(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 320 * textScale),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              indicator,
              const SizedBox(width: AppSpacing.md),
              Flexible(
                child: Text(
                  label,
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
