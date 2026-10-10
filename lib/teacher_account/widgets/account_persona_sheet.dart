import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/bloc/account_persona_form_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/account_role_selector.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/teacher_picker.dart';

Future<bool?> showAccountPersonaSheet(
  BuildContext context, {
  AccountRole? initialRole,
}) {
  final cubit = context.read<AccountPersonaCubit>();
  return showAppSheet<bool>(
    context,
    title: context.l10n.accountPersonaTitle,
    subtitle: context.l10n.accountPersonaSubtitle,
    child: BlocProvider.value(
      value: cubit,
      child: AccountPersonaSheet(initialRole: initialRole),
    ),
  );
}

class AccountPersonaSheet extends StatelessWidget {
  const AccountPersonaSheet({this.initialRole, super.key});

  final AccountRole? initialRole;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => AccountPersonaFormCubit(
      account: context.read<AccountPersonaCubit>(),
      initialRole: initialRole,
    ),
    child: BlocConsumer<AccountPersonaFormCubit, AccountPersonaFormState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) => _AccountPersonaForm(state: state),
    ),
  );
}

class _AccountPersonaForm extends StatelessWidget {
  const _AccountPersonaForm({required this.state});

  final AccountPersonaFormState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final form = context.read<AccountPersonaFormCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AccountRoleSelector(
          role: state.role,
          onChanged: state.busy ? null : form.selectRole,
        ),
        if (state.role == AccountRole.teacher) ...[
          const SizedBox(height: AppSpacing.sectionGap),
          if (state.teacherUnavailable) ...[
            AppBanner(
              message: l10n.teacherUnavailableDescription,
              tone: AppBannerTone.warn,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          TeacherPicker(
            selected: state.teacher,
            enabled: !state.busy,
            onSelected: form.selectTeacher,
          ),
          if (state.teacher != null)
            AppButton.text(
              label: l10n.teacherDisconnect,
              onPressed: state.busy ? null : form.clearTeacher,
            ),
        ],
        if (state.failed) ...[
          const SizedBox(height: AppSpacing.md),
          AppBanner(message: l10n.identitySaveError, tone: AppBannerTone.warn),
        ],
        const SizedBox(height: AppSpacing.sectionGap),
        AppButton.primary(
          key: const Key('accountPersona_save'),
          label: l10n.accountPersonaSave,
          expanded: true,
          size: AppButtonSize.large,
          loading: state.busy,
          onPressed: state.busy || !state.canSubmit
              ? null
              : () {
                  FocusScope.of(context).unfocus();
                  unawaited(form.save());
                },
        ),
      ],
    );
  }
}
