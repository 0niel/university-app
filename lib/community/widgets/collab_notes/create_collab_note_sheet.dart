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
          style: NinjaText.microLabel.copyWith(
            color: context.ninja.muted,
          ),
        ),
        const SizedBox(height: 8),
        NinjaSegmented<CollabNoteVisibility>(
          value: _visibility,
          onChanged: (value) => setState(() => _visibility = value),
          expanded: true,
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
        const SizedBox(height: 12),
        NinjaInput(
          controller: _controller,
          autofocus: true,
          maxLength: 200,
          textInputAction: .done,
          onSubmitted: (_) => unawaited(_save()),
          placeholder: context.l10n.collabNotesTitleExampleHint,
        ),
        const SizedBox(height: 18),
        NinjaButton.primary(
          label: saving
              ? context.l10n.collabNotesCreating
              : context.l10n.collabNotesCreate,
          expanded: true,
          onPressed: saving ? null : () => unawaited(_save()),
        ),
      ],
    );
  }
}
