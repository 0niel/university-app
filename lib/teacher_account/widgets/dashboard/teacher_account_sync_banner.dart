import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';

enum _TeacherAccountSyncIssue { pendingChoice, accountUnavailable }

class TeacherAccountSyncBanner extends StatelessWidget {
  const TeacherAccountSyncBanner({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocSelector<
        AccountPersonaCubit,
        AccountPersonaState,
        _TeacherAccountSyncIssue?
      >(
        selector: (state) => !state.syncError
            ? null
            : state.pendingSync
            ? _TeacherAccountSyncIssue.pendingChoice
            : _TeacherAccountSyncIssue.accountUnavailable,
        builder: (context, issue) => issue != null
            ? Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: AppBanner(
                  message: issue == _TeacherAccountSyncIssue.pendingChoice
                      ? context.l10n.accountPersonaSyncError
                      : context.l10n.accountPersonaLoadError,
                  tone: AppBannerTone.warn,
                  actionLabel: context.l10n.retry,
                  onAction: () =>
                      unawaited(context.read<AccountPersonaCubit>().retry()),
                ),
              )
            : const SizedBox.shrink(),
      );
}
