import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ScheduleSheetToggleRow extends StatelessWidget {
  const ScheduleSheetToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
    this.subtitle,
    this.first = false,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final bool first;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final subtitle = this.subtitle;
    return Padding(
      padding: .only(top: first ? 0 : 4),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: NinjaMetrics.minTouchTarget,
        ),
        child: Padding(
          padding: const .symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      title,
                      style: NinjaText.body.copyWith(color: colors.ink),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: NinjaText.subtext.copyWith(color: colors.muted),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              NinjaSwitch(value: value, onChanged: onChanged),
            ],
          ),
        ),
      ),
    );
  }
}
