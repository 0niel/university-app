import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_dashboard_binding.dart';

class TeacherAccountShortcut extends StatelessWidget {
  const TeacherAccountShortcut({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountPersonaCubit?>()?.state;
    if (account?.isTeacher != true) return const SizedBox.shrink();
    final l10n = context.l10n;
    final colors = context.colors;
    final binding = TeacherDashboardBinding.fromAccount(account!);
    final (label, description) = switch (binding) {
      TeacherBindingReady(:final value) => (
        value.name,
        l10n.teacherCabinetEntryDescription,
      ),
      TeacherBindingRestoring() => (
        l10n.teacherCabinetEntryRestoring,
        l10n.teacherCabinetEntryDescription,
      ),
      TeacherBindingUnselected() => (
        l10n.teacherChooseTitle,
        l10n.teacherChooseDescription,
      ),
      TeacherBindingUnavailable() => (
        l10n.teacherUnavailableTitle,
        l10n.teacherUnavailableDescription,
      ),
    };
    final restoring = binding is TeacherBindingRestoring;
    return AppCard(
      key: const ValueKey('teacher-account-shortcut'),
      semanticsLabel: '${l10n.teacherCabinetTitle}, $label, $description',
      onTap: restoring
          ? null
          : () => unawaited(context.push<void>('/profile/teacher')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIconTile(
                icon: AppLineIcon.clipboard,
                size: AppControlSize.touchTarget,
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
                      label,
                      maxLines: binding is TeacherBindingReady ? 2 : null,
                      overflow: binding is TeacherBindingReady
                          ? TextOverflow.ellipsis
                          : null,
                      style: AppText.subtextStrong.copyWith(
                        color: binding is TeacherBindingUnavailable
                            ? colors.warn
                            : binding is TeacherBindingUnselected
                            ? colors.accent
                            : colors.ink,
                      ),
                    ),
                  ],
                ),
              ),
              if (!restoring) ...[
                const SizedBox(width: AppSpacing.sm),
                AppLineIconWidget(
                  AppLineIcon.chevronR,
                  size: AppIconSize.compact,
                  color: colors.muted,
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            description,
            style: AppText.subtext.copyWith(color: colors.muted),
          ),
          if (restoring) ...[
            const SizedBox(height: AppSpacing.md),
            LinearProgressIndicator(
              color: colors.accent,
              backgroundColor: colors.line,
              minHeight: 2,
              semanticsLabel: l10n.loadingContent,
            ),
          ],
        ],
      ),
    );
  }
}
