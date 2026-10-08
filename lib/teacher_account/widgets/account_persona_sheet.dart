import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/account_role_selector.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/teacher_picker.dart';
import 'package:schedule_repository/schedule_repository.dart';

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

class AccountPersonaSheet extends StatefulWidget {
  const AccountPersonaSheet({this.initialRole, super.key});

  final AccountRole? initialRole;

  @override
  State<AccountPersonaSheet> createState() => _AccountPersonaSheetState();
}

class _AccountPersonaSheetState extends State<AccountPersonaSheet> {
  late final AccountPersonaCubit _cubit;
  late AccountRole _role;
  Teacher? _teacher;
  var _saving = false;
  var _failed = false;
  var _unlink = false;
  var _teacherEdited = false;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<AccountPersonaCubit>();
    _role = widget.initialRole ?? _cubit.state.persona.role;
    _teacher = _cubit.state.teacher;
  }

  Future<void> _save() async {
    if (_saving || _cubit.isClosed) return;
    setState(() {
      _saving = true;
      _failed = false;
    });
    FocusScope.of(context).unfocus();
    final saved = await _cubit.configure(
      role: _role,
      teacher: _teacherEdited ? _teacher : null,
      clearTeacher: _unlink,
    );
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _saving = false;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final persona = context.watch<AccountPersonaCubit>().state.persona;
    final changed = _role != persona.role || _teacherEdited || _unlink;
    final unavailable =
        _teacher?.uid == persona.teacherId &&
        persona.teacherId != null &&
        !persona.teacherAvailable &&
        !_teacherEdited;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AccountRoleSelector(
          role: _role,
          onChanged: _saving ? null : (role) => setState(() => _role = role),
        ),
        if (_role == AccountRole.teacher) ...[
          const SizedBox(height: AppSpacing.sectionGap),
          if (unavailable) ...[
            AppBanner(
              message: l10n.teacherUnavailableDescription,
              tone: AppBannerTone.warn,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          TeacherPicker(
            selected: _teacher,
            enabled: !_saving,
            onSelected: (teacher) => setState(() {
              _teacher = teacher;
              _unlink = false;
              _teacherEdited = true;
            }),
          ),
          if (_teacher != null)
            AppButton.text(
              label: l10n.teacherDisconnect,
              onPressed: _saving
                  ? null
                  : () => setState(() {
                      _teacher = null;
                      _unlink = true;
                      _teacherEdited = false;
                    }),
            ),
        ],
        if (_failed) ...[
          const SizedBox(height: AppSpacing.md),
          AppBanner(message: l10n.identitySaveError, tone: AppBannerTone.warn),
        ],
        const SizedBox(height: AppSpacing.sectionGap),
        AppButton.primary(
          key: const Key('accountPersona_save'),
          label: l10n.accountPersonaSave,
          expanded: true,
          size: AppButtonSize.large,
          loading: _saving,
          onPressed: _saving || !changed ? null : () => unawaited(_save()),
        ),
      ],
    );
  }
}
