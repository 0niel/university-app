import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/collab_notes/collab_notes.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CreateCollabNoteSheet extends StatefulWidget {
  const CreateCollabNoteSheet({super.key});

  @override
  State<CreateCollabNoteSheet> createState() => _CreateCollabNoteSheetState();
}

class _CreateCollabNoteSheetState extends State<CreateCollabNoteSheet> {
  final _controller = TextEditingController();
  CollabNoteVisibility _visibility = .group;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (context.read<CollabNotesCubit>().state.isCreating) return;
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    final note = await context.read<CollabNotesCubit>().create(
      title: title,
      visibility: _visibility,
    );
    if (!mounted) return;
    if (note != null) {
      Navigator.of(context).pop(note);
    } else {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.collabNotesCreateError,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final saving = context.select<CollabNotesCubit, bool>(
      (cubit) => cubit.state.isCreating,
    );
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        Text(
          context.l10n.collabNotesVisibilityLabel,
          style: AppText.captionSmall.copyWith(
            color: context.colors.muted,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        NinjaSegmented<CollabNoteVisibility>(
          value: _visibility,
          onChanged: saving
              ? null
              : (value) => setState(() => _visibility = value),
          segments: [
            NinjaSegment(
              value: CollabNoteVisibility.group,
              label: context.l10n.collabNotesVisibilityGroup,
            ),
            NinjaSegment(
              value: CollabNoteVisibility.personal,
              label: context.l10n.collabNotesVisibilityPersonal,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        NinjaInput(
          controller: _controller,
          enabled: !saving,
          autofocus: true,
          maxLength: 200,
          textInputAction: .done,
          onSubmitted: (_) => unawaited(_save()),
          placeholder: context.l10n.collabNotesTitleExampleHint,
        ),
        const SizedBox(height: AppSpacing.fieldGap),
        NinjaButton.primary(
          label: saving
              ? context.l10n.collabNotesCreating
              : context.l10n.collabNotesCreate,
          expanded: true,
          size: NinjaButtonSize.large,
          loading: saving,
          onPressed: saving ? null : () => unawaited(_save()),
        ),
      ],
    );
  }
}
