import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CreateGroupSheet extends StatefulWidget {
  const CreateGroupSheet({required this.onCreate, super.key});

  final Future<bool> Function({
    required String name,
    required String emoji,
    required String description,
    required bool isDiscoverable,
  })
  onCreate;

  @override
  State<CreateGroupSheet> createState() => _CreateGroupSheetState();
}

class _CreateGroupSheetState extends State<CreateGroupSheet> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  String _emoji = '🎓';
  bool _discoverable = true;
  bool _saving = false;

  static const _emojis = ['🎓', '📚', '🚀', '💡', '🔥', '🎯', '🤝', '🧠'];

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty || _saving) return;
    setState(() => _saving = true);
    try {
      final ok = await widget.onCreate(
        name: name,
        emoji: _emoji,
        description: _description.text.trim(),
        isDiscoverable: _discoverable,
      );
      if (!mounted) return;
      if (ok) {
        Navigator.of(context).pop(true);
      } else {
        setState(() => _saving = false);
      }
    } on Exception catch (error, stackTrace) {
      log(
        'Study group creation failed',
        error: error,
        stackTrace: stackTrace,
        name: 'CreateGroupSheet',
      );
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final emoji in _emojis)
              Semantics(
                button: true,
                selected: _emoji == emoji,
                label: emoji,
                child: AppPressable(
                  onTap: () => setState(() => _emoji = emoji),
                  child: AnimatedContainer(
                    duration: NinjaMotion.of(context, NinjaMotion.fast),
                    curve: NinjaMotion.enter,
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _emoji == emoji ? colors.accent : colors.surface2,
                      borderRadius: .circular(AppRadius.field),
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 22)),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        NinjaInput(
          controller: _name,
          autofocus: true,
          maxLength: 80,
          placeholder: l10n.studyGroupNameHint,
        ),
        const SizedBox(height: 10),
        NinjaInput.multiline(
          controller: _description,
          minLines: 2,
          maxLines: 4,
          placeholder: l10n.studyGroupDescriptionHint,
        ),
        const SizedBox(height: 14),
        Semantics(
          button: true,
          toggled: _discoverable,
          label: l10n.studyGroupDiscoverableLabel,
          child: AppPressable(
            onTap: () => setState(() => _discoverable = !_discoverable),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: AppControlSize.touchTarget,
              ),
              padding: const .fromLTRB(16, 10, 12, 10),
              decoration: BoxDecoration(
                color: colors.surface2,
                borderRadius: .circular(AppRadius.field),
              ),
              child: Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: Text(
                      l10n.studyGroupDiscoverableLabel,
                      style: AppText.body.copyWith(color: colors.ink),
                    ),
                  ),
                  ExcludeSemantics(
                    child: NinjaSwitch(
                      value: _discoverable,
                      onChanged: (value) =>
                          setState(() => _discoverable = value),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        NinjaButton.primary(
          label: _saving
              ? l10n.studyGroupCreating
              : l10n.studyGroupCreateButton,
          expanded: true,
          size: NinjaButtonSize.large,
          onPressed: _saving ? null : () => unawaited(_save()),
        ),
      ],
    );
  }
}
