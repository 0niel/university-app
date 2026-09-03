import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/people/cubit/group_space/group_space_cubit.dart';

class GroupPostSheet extends StatefulWidget {
  const GroupPostSheet({required this.announcement, super.key});

  final bool announcement;

  @override
  State<GroupPostSheet> createState() => _GroupPostSheetState();
}

class _GroupPostSheetState extends State<GroupPostSheet> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _title = '';
  String _body = '';
  bool _saving = false;
  bool _submitted = false;
  bool _pinned = false;

  bool get _valid => _title.trim().isNotEmpty || _body.trim().isNotEmpty;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _submitted = true);
    if (!_valid || _saving) return;
    setState(() => _saving = true);
    final saved = await context.read<GroupSpaceCubit>().createPost(
      title: _title.trim(),
      body: _body.trim(),
      announcement: widget.announcement,
      pinned: widget.announcement || _pinned,
    );
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop();
    } else {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isOwner = context.watch<GroupSpaceCubit>().state.space.isOwner;
    return SingleChildScrollView(
      child: Column(
        spacing: 12,
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          NinjaInput(
            controller: _titleController,
            onChanged: (value) => setState(() => _title = value),
            autofocus: true,
            placeholder: widget.announcement
                ? l10n.groupSpacePostTitleHintAnnouncement
                : l10n.groupSpacePostTitleHintNote,
            errorText: _submitted && !_valid
                ? l10n.groupSpacePostEmptyError
                : null,
          ),
          AppInputField.multiline(
            controller: _bodyController,
            onChanged: (value) => setState(() => _body = value),
            placeholder: l10n.groupSpacePostBodyHint,
            maxLength: 8000,
          ),
          if (!widget.announcement && isOwner)
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.surface2,
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: AppSettingsToggleRow(
                isFirst: true,
                title: l10n.groupSpacePostPinToggle,
                value: _pinned,
                onChanged: (value) => setState(() => _pinned = value),
              ),
            ),
          NinjaButton.primary(
            label: _saving ? l10n.groupSpacePublishing : l10n.groupSpacePublish,
            expanded: true,
            onPressed: _saving ? null : () => unawaited(_save()),
          ),
        ],
      ),
    );
  }
}
