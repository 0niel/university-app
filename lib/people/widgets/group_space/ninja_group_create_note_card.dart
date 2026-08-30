import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NinjaGroupCreateNoteCard extends StatelessWidget {
  const NinjaGroupCreateNoteCard({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Padding(
      padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
      child: AppPressable(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: NinjaMetrics.minTouchTarget,
          ),
          padding: const .symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: .circular(NinjaRadius.card),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.groupSpaceNotesPlaceholder,
                  style: NinjaText.subtext.copyWith(color: colors.muted),
                ),
              ),
              AppLineIconWidget(.plus, size: 20, color: colors.ink),
            ],
          ),
        ),
      ),
    );
  }
}
