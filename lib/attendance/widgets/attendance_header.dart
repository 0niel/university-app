import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class AttendanceHeader extends StatelessWidget {
  const AttendanceHeader({required this.onAdd, super.key});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final top = math.max(
      AppSpacing.screenTop,
      MediaQuery.paddingOf(context).top + 12,
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        top,
        AppSpacing.screen,
        0,
      ),
      child: Row(
        children: [
          AppBackButton(onPressed: () => Navigator.of(context).maybePop()),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              l10n.attendanceTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.displaySmall.copyWith(color: colors.ink),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          AppHeaderCircleButton(
            size: AppControlSize.iconButton,
            background: colors.accent,
            foreground: colors.onAccent,
            action: AppHeaderAction(
              icon: AppLineIcon.plus,
              onTap: onAdd,
              semanticsLabel: l10n.attendanceAddAbsence,
            ),
          ),
        ],
      ),
    );
  }
}
