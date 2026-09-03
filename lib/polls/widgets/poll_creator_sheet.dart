import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/polls/cubit/polls_cubit.dart';

part 'add_option_button.dart';
part 'expiry_chip.dart';
part 'option_field.dart';
part 'toggle_row.dart';

enum _Expiry { none, day, threeDays, week }

extension on _Expiry {
  Duration? get duration => switch (this) {
    .none => null,
    .day => const .new(days: 1),
    .threeDays => const .new(days: 3),
    .week => const .new(days: 7),
  };

  String label(AppLocalizations l10n) => switch (this) {
    .none => l10n.pollsExpiryNone,
    .day => l10n.pollsExpiry24h,
    .threeDays => l10n.pollsExpiry3d,
    .week => l10n.pollsExpiry7d,
  };
}

class PollCreatorSheet extends StatefulWidget {
  const PollCreatorSheet({required this.cubit, super.key});

  final PollsCubit cubit;

  @override
  State<PollCreatorSheet> createState() => _PollCreatorSheetState();
}

class _PollCreatorSheetState extends State<PollCreatorSheet> {
  static const _minOptions = 2;
  static const _maxOptions = 8;

  final _question = TextEditingController();
  final _options = [
    TextEditingController(),
    TextEditingController(),
  ];

  PollType _type = .single;
  bool _anonymous = false;
  bool _showResults = true;
  _Expiry _expiry = .none;
  int _correctIndex = 0;
  bool _saving = false;
  bool _failed = false;

  @override
  void dispose() {
    _question.dispose();
    for (final option in _options) {
      option.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    if (_options.length >= _maxOptions) return;
    setState(() => _options.add(TextEditingController()));
  }

  void _removeOption(int index) {
    if (_options.length <= _minOptions) return;
    setState(() {
      final removed = _options.removeAt(index);
      WidgetsBinding.instance.addPostFrameCallback((_) => removed.dispose());
      if (index < _correctIndex) {
        _correctIndex--;
      } else if (_correctIndex >= _options.length) {
        _correctIndex = _options.length - 1;
      }
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    final question = _question.text.trim();
    final options = <String>[];
    int? correctIndex;
    for (final (index, option) in _options.indexed) {
      final value = option.text.trim();
      if (value.isEmpty) continue;
      if (index == _correctIndex) correctIndex = options.length;
      options.add(value);
    }
    if (question.isEmpty || options.length < _minOptions) return;
    if (_type == .quiz && correctIndex == null) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _saving = true;
      _failed = false;
    });
    final expiresAt = _expiry.duration == null
        ? null
        : DateTime.now().add(_expiry.duration ?? .zero);
    final created = await widget.cubit.createPoll(
      question: question,
      options: options,
      type: _type,
      isAnonymous: _anonymous,
      showResults: _showResults,
      expiresAt: expiresAt,
      correctIndex: _type == .quiz ? correctIndex : null,
    );
    if (!mounted) return;
    if (created) {
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
    final colors = context.colors;
    final l10n = context.l10n;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        NinjaSegmented<PollType>(
          value: _type,
          onChanged: (value) => setState(() => _type = value),
          segments: [
            NinjaSegment(value: PollType.single, label: l10n.pollsTypeSingle),
            NinjaSegment(value: PollType.multi, label: l10n.pollsTypeMultiple),
            NinjaSegment(value: PollType.quiz, label: l10n.pollsTypeQuiz),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        NinjaInput.multiline(
          controller: _question,
          autofocus: true,
          maxLength: 140,
          minLines: 1,
          maxLines: 3,
          placeholder: l10n.pollsQuestionHint,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.pollsOptionsLabel,
          style: AppText.headline.copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final (index, controller) in _options.indexed) ...[
          _OptionField(
            key: ValueKey(controller),
            controller: controller,
            hint: l10n.pollsOptionHint(index + 1),
            isQuiz: _type == .quiz,
            isCorrect: _correctIndex == index,
            onMarkCorrect: () => setState(() => _correctIndex = index),
            canRemove: _options.length > _minOptions,
            onRemove: () => _removeOption(index),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (_options.length < _maxOptions)
          _AddOptionButton(label: l10n.pollsAddOption, onTap: _addOption),
        const SizedBox(height: AppSpacing.fieldGap),
        Text(
          l10n.pollsSettings,
          style: AppText.headline.copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSpacing.sm),
        _ToggleRow(
          title: l10n.pollsAnonymous,
          subtitle: l10n.pollsAnonymousSub,
          value: _anonymous,
          onChanged: (value) => setState(() => _anonymous = value),
        ),
        const SizedBox(height: AppSpacing.sm),
        _ToggleRow(
          title: l10n.pollsShowResults,
          value: _showResults,
          onChanged: (value) => setState(() => _showResults = value),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.pollsExpiry,
          style: AppText.body.copyWith(
            color: colors.muted,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final expiry in _Expiry.values)
              _ExpiryChip(
                label: expiry.label(l10n),
                selected: _expiry == expiry,
                onTap: () => setState(() => _expiry = expiry),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.fieldGap),
        if (_failed) ...[
          Semantics(
            liveRegion: true,
            child: AppBanner(
              message: l10n.pollsCreateError,
              tone: AppBannerTone.danger,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        NinjaButton.primary(
          label: _saving ? l10n.pollsCreating : l10n.pollsCreate,
          expanded: true,
          size: NinjaButtonSize.large,
          loading: _saving,
          onPressed: _saving ? null : () => unawaited(_save()),
        ),
      ],
    );
  }
}
