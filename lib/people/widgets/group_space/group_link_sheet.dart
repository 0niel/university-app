import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/people/cubit/group_space/group_space_cubit.dart';

class GroupLinkSheet extends StatefulWidget {
  const GroupLinkSheet({required this.telegram, super.key});

  final bool telegram;

  @override
  State<GroupLinkSheet> createState() => _GroupLinkSheetState();
}

class _GroupLinkSheetState extends State<GroupLinkSheet> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  String _title = '';
  String _url = '';
  bool _saving = false;
  bool _submitted = false;

  GroupLinkAddress? get _address => GroupLinkAddress.tryParse(
    _url,
    telegramOnly: widget.telegram,
  );

  bool get _valid => _title.trim().isNotEmpty && _address != null;

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _submitted = true);
    final address = _address;
    if (!_valid || address == null || _saving) return;
    setState(() => _saving = true);
    final saved = await context.read<GroupSpaceCubit>().addLink(
      title: _title.trim(),
      url: address.toString(),
      emoji: widget.telegram ? '✈️' : '🔗',
      kind: widget.telegram ? 'telegram' : 'link',
    );
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop();
    } else {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      spacing: 12,
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        NinjaInput(
          controller: _urlController,
          autofocus: true,
          keyboardType: .url,
          onChanged: (value) => setState(() => _url = value),
          label: widget.telegram
              ? context.l10n.groupSpaceLinkSheetHandleLabel
              : context.l10n.groupSpaceLinkSheetUrlLabel,
          placeholder: widget.telegram
              ? context.l10n.groupSpaceLinkSheetTgHint
              : context.l10n.groupSpaceLinkSheetUrlHint,
          errorText: _submitted && _address == null ? context.l10n.error : null,
        ),
        NinjaInput(
          controller: _titleController,
          onChanged: (value) => setState(() => _title = value),
          label: context.l10n.groupSpaceLinkSheetTitleLabel,
          placeholder: widget.telegram
              ? context.l10n.groupSpaceLinkSheetTitleHintTg
              : context.l10n.groupSpaceLinkSheetTitleHint,
          errorText: _submitted && _title.trim().isEmpty
              ? context.l10n.error
              : null,
        ),
        NinjaButton.primary(
          label: _saving
              ? context.l10n.groupSpaceSaving
              : widget.telegram
              ? context.l10n.groupSpaceSaveTelegram
              : context.l10n.groupSpaceSaveLink,
          expanded: true,
          onPressed: _saving ? null : () => unawaited(_save()),
        ),
      ],
    ),
  );
}
