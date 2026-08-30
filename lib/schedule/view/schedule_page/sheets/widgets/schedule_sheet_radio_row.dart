import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ScheduleSheetRadioRow extends StatelessWidget {
  const ScheduleSheetRadioRow({
    required this.title,
    required this.selected,
    required this.onTap,
    super.key,
    this.subtitle,
    this.first = false,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final bool first;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final subtitle = this.subtitle;
    return Semantics(
      button: true,
      selected: selected,
      child: Padding(
        padding: .only(top: first ? 0 : 4),
        child: AppPressable(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: NinjaMetrics.minTouchTarget,
            ),
            padding: const .symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? colors.infoTint : Colors.transparent,
              borderRadius: .circular(NinjaRadius.control),
            ),
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
                          style: NinjaText.subtext.copyWith(
                            color: colors.muted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                NinjaRadio<bool>(
                  value: true,
                  groupValue: selected,
                  onChanged: (_) => onTap(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
