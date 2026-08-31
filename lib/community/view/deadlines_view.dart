import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/community/widgets/create_deadline_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/deadline_widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class DeadlinesView extends StatelessWidget {
  const DeadlinesView({super.key});

  Future<void> _createDeadline(BuildContext context) async {
    final cubit = context.read<DeadlinesCubit>();
    if (cubit.state.isCreating) return;
    final draft = await showAppSheet<DeadlineDraft>(
      context,
      title: context.l10n.createDeadlineTitle,
      child: const CreateDeadlineSheet(),
    );
    if (draft == null || !context.mounted) return;
    final created = await cubit.createDeadline(draft);
    if (!created && context.mounted) {
      _showError(context, context.l10n.deadlinesCreateError);
    }
  }

  Future<void> _toggleDone(BuildContext context, String deadlineId) async {
    final changed = await context.read<DeadlinesCubit>().toggleDone(deadlineId);
    if (!changed && context.mounted) {
      _showError(context, context.l10n.deadlinesUpdateError);
    }
  }

  void _showError(BuildContext context, String message) {
    showNinjaToast(context, message: message, showCheck: false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeadlinesCubit, DeadlinesState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == .failure &&
          current.deadlines.isNotEmpty,
      listener: (context, _) =>
          _showError(context, context.l10n.deadlinesRefreshError),
      builder: (context, state) => Scaffold(
        backgroundColor: context.ninja.canvas,
        body: SafeArea(
          bottom: false,
          child: DeadlinesBody(
            state: state,
            onCreate: state.isCreating
                ? null
                : () => unawaited(_createDeadline(context)),
            onToggle: (id) => unawaited(_toggleDone(context, id)),
          ),
        ),
      ),
    );
  }
}
