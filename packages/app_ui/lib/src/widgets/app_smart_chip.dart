import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppSmartChip extends StatelessWidget {
  const AppSmartChip({
    required this.emoji,
    required this.label,
    required this.value,
    required this.tone,
    super.key,
  }) : icon = null;

  const AppSmartChip.icon({
    required this.icon,
    required this.label,
    required this.value,
    required this.tone,
    super.key,
  }) : emoji = null;

  final String? emoji;
  final Widget? icon;
  final String label;
  final String value;

  final Color tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Semantics(
      container: true,
      label: '$label, $value',
      child: ExcludeSemantics(
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            color: colors.surfaceAlt,
            borderRadius: BorderRadius.circular(NinjaRadius.button),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 3,
                height: 30,
                decoration: BoxDecoration(
                  color: tone,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 9),
              icon ??
                  Text(
                    emoji ?? '',
                    style: const TextStyle(fontSize: 20, height: 1),
                  ),
              const SizedBox(width: AppSpacing.gap),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: NinjaText.helper.copyWith(color: colors.muted),
                    ),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: NinjaText.body.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
