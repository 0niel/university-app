import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';

class TeacherAccountShortcut extends StatelessWidget {
  const TeacherAccountShortcut({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountPersonaCubit?>()?.state;
    if (account?.isTeacher != true) return const SizedBox.shrink();
    final l10n = context.l10n;
    final colors = context.colors;
    return AppCard(
      key: const ValueKey('teacher-account-shortcut'),
      semanticsLabel: l10n.teacherCabinetTitle,
      onTap: () => unawaited(context.push<void>('/profile/teacher')),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconTile(
            icon: AppLineIcon.clipboard,
            size: 44,
            background: colors.tintOf(colors.accent),
            foreground: colors.accent,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.teacherCabinetTitle,
                  style: AppText.headlineStrong.copyWith(color: colors.ink),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  account?.persona.teacherAvailable == true
                      ? account?.teacher?.name ?? l10n.teacherChooseTitle
                      : account?.persona.teacherId != null
                      ? l10n.teacherUnavailableTitle
                      : l10n.teacherChooseTitle,
                  style: AppText.subtext.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppLineIconWidget(
            AppLineIcon.chevronR,
            size: 18,
            color: colors.muted,
          ),
        ],
      ),
    );
  }
}
