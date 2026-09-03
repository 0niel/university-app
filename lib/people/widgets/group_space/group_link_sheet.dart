import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/people/cubit/group_space/group_space_cubit.dart';

enum _LinkCategory { study, drive, duty, records, other }

extension on _LinkCategory {
  String emoji() => switch (this) {
    _LinkCategory.study => '📚',
    _LinkCategory.drive => '💾',
    _LinkCategory.duty => '🗓️',
    _LinkCategory.records => '🎥',
    _LinkCategory.other => '🔗',
  };

  String label(AppLocalizations l10n) => switch (this) {
    _LinkCategory.study => l10n.groupSpaceCatStudy,
    _LinkCategory.drive => l10n.groupSpaceCatDrive,
    _LinkCategory.duty => l10n.groupSpaceCatDuty,
    _LinkCategory.records => l10n.groupSpaceCatRecords,
    _LinkCategory.other => l10n.groupSpaceCatOther,
  };
}

String? _recognizedLabel(AppLocalizations l10n, String url) {
  final lower = url.toLowerCase();
  if (lower.contains('drive.google.')) return l10n.groupSpaceRecognizedDrive;
  if (lower.contains('docs.google.')) return l10n.groupSpaceRecognizedDocs;
  if (lower.contains('github.com')) return l10n.groupSpaceRecognizedGithub;
  if (lower.contains('youtube.com') || lower.contains('youtu.be')) {
    return l10n.groupSpaceRecognizedYoutube;
  }
  if (lower.contains('lms') || lower.contains('do.mirea.')) {
    return l10n.groupSpaceRecognizedLms;
  }
  return null;
}

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
  _LinkCategory _category = _LinkCategory.other;

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
      emoji: widget.telegram ? '✈️' : _category.emoji(),
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
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final recognized = widget.telegram ? null : _recognizedLabel(l10n, _url);
    return SingleChildScrollView(
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
                ? l10n.groupSpaceLinkSheetHandleLabel
                : l10n.groupSpaceLinkSheetUrlLabel,
            placeholder: widget.telegram
                ? l10n.groupSpaceLinkSheetTgHint
                : l10n.groupSpaceLinkSheetUrlHint,
            errorText: _submitted && _address == null ? l10n.error : null,
          ),
          if (recognized != null)
            Text(
              '${l10n.groupSpaceLinkRecognized}: $recognized',
              style: AppText.captionSmall.copyWith(
                color: context.colors.muted,
              ),
            ),
          NinjaInput(
            controller: _titleController,
            onChanged: (value) => setState(() => _title = value),
            label: l10n.groupSpaceLinkSheetTitleLabel,
            placeholder: widget.telegram
                ? l10n.groupSpaceLinkSheetTitleHintTg
                : l10n.groupSpaceLinkSheetTitleHint,
            errorText: _submitted && _title.trim().isEmpty ? l10n.error : null,
          ),
          if (!widget.telegram) ...[
            Text(
              l10n.groupSpaceLinkSheetCategoryLabel,
              style: AppText.captionSmall.copyWith(
                color: context.colors.muted,
              ),
            ),
            AppChipRow<_LinkCategory>(
              value: _category,
              onChanged: (value) => setState(() => _category = value),
              items: [
                for (final category in _LinkCategory.values)
                  AppChipRowItem(
                    value: category,
                    label: '${category.emoji()} ${category.label(l10n)}',
                  ),
              ],
            ),
          ],
          NinjaButton.primary(
            label: _saving
                ? l10n.groupSpaceSaving
                : widget.telegram
                ? l10n.groupSpaceSaveTelegram
                : l10n.groupSpaceSaveLink,
            expanded: true,
            onPressed: _saving ? null : () => unawaited(_save()),
          ),
        ],
      ),
    );
  }
}
