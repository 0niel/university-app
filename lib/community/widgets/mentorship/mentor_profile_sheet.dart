import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/mentorship/mentorship.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/community/view/mentorship_labels.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MentorProfileSheet extends StatefulWidget {
  const MentorProfileSheet({super.key, this.current});

  final Mentor? current;

  @override
  State<MentorProfileSheet> createState() => _MentorProfileSheetState();
}

class _MentorProfileSheetState extends State<MentorProfileSheet> {
  late final _bio = TextEditingController(text: widget.current?.bio ?? '');
  late final _telegram = TextEditingController(
    text: widget.current?.telegramHandle ?? '',
  );
  final _customTopic = TextEditingController();
  late final Set<String> _topics = {...?widget.current?.topics};
  late final Set<String> _formats = {...?widget.current?.formats};
  late String _level = _initialLevel;
  var _telegramTouched = false;
  var _saveFailed = false;
  var _submitting = false;

  String get _initialLevel {
    final current = widget.current?.level.trim() ?? '';
    return current.isEmpty
        ? (UniversityConfig.current.mentorLevelKeys.firstOrNull ?? '')
        : current;
  }

  @override
  void dispose() {
    _bio.dispose();
    _telegram.dispose();
    _customTopic.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_submitting || context.read<MentorshipCubit>().state.isSavingProfile) {
      return;
    }
    if (!_validTopics || !isValidMentorTelegramHandle(_telegram.text)) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _saveFailed = false;
      _submitting = true;
    });
    final saved = await context.read<MentorshipCubit>().saveProfile(
      MentorProfileDraft(
        topics: _topicsToSave.toList(growable: false),
        telegramHandle: _telegram.text,
        bio: _bio.text,
        level: _level,
        formats: _formats.toList(growable: false),
      ),
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (saved) {
      Navigator.of(context).pop();
    } else {
      setState(() => _saveFailed = true);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showNinjaConfirmDialog(
      context,
      title: context.l10n.mentorshipQuitConfirmTitle,
      message: context.l10n.mentorshipQuitConfirmBody,
      confirmLabel: context.l10n.mentorshipQuit,
      cancelLabel: context.l10n.collabNotesCancel,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    final deleted = await context.read<MentorshipCubit>().deleteProfile();
    if (!mounted) return;
    if (deleted) {
      Navigator.of(context).pop();
    } else {
      _showError(context.l10n.mentorshipProfileDeleteError);
    }
  }

  void _showError(String message) {
    showNinjaToast(context, showCheck: false, message: message);
  }

  String get _pendingTopic {
    final value = _customTopic.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (value.isEmpty) return '';
    return {
          ...UniversityConfig.current.mentorTopicKeys,
          ..._topics,
        }.firstWhereOrNull(
          (topic) =>
              topic.toLowerCase() == value.toLowerCase() ||
              mentorTopicLabel(context.l10n, topic).toLowerCase() ==
                  value.toLowerCase(),
        ) ??
        value;
  }

  Set<String> get _topicsToSave => {
    ..._topics,
    if (_pendingTopic.isNotEmpty) _pendingTopic,
  };

  bool get _validTopics =>
      _topicsToSave.isNotEmpty &&
      _topicsToSave.length <= 20 &&
      _topicsToSave.every((topic) => topic.runes.length <= 60);

  void _addTopic() {
    if (!_validTopics ||
        _pendingTopic.isEmpty ||
        _submitting ||
        context.read<MentorshipCubit>().state.isSavingProfile) {
      return;
    }
    setState(() {
      _topics.add(_pendingTopic);
      _customTopic.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = UniversityConfig.current;
    final stateSaving = context.select<MentorshipCubit, bool>(
      (cubit) => cubit.state.isSavingProfile,
    );
    final saving = stateSaving || _submitting;
    final topicKeys = {...config.mentorTopicKeys, ..._topics};
    final levelKeys = {...config.mentorLevelKeys, _level};
    final formatKeys = {...config.mentorFormatKeys, ..._formats};
    final fields = <Widget>[
      if (_saveFailed)
        AppBanner(
          message: context.l10n.mentorshipProfileSaveError,
          tone: .danger,
        ),
      AppInputField(
        key: const Key('mentorProfile_telegram'),
        controller: _telegram,
        enabled: !saving,
        label: context.l10n.mentorshipTelegramLabel,
        placeholder: context.l10n.mentorshipTelegramPlaceholder,
        leadingIcon: AppLineIcon.at,
        textInputAction: .next,
        errorText:
            _telegramTouched && !isValidMentorTelegramHandle(_telegram.text)
            ? context.l10n.mentorshipTelegramError
            : null,
        onChanged: (_) => setState(() => _telegramTouched = true),
      ),
      AppFieldLabel(context.l10n.mentorshipTopicsLabel),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final topic in topicKeys)
            NinjaChip(
              label: mentorTopicLabel(context.l10n, topic),
              selected: _topics.contains(topic),
              enabled:
                  !saving && (_topics.contains(topic) || _topics.length < 20),
              onTap: saving
                  ? null
                  : () => setState(() {
                      if (_topics.contains(topic)) {
                        _topics.remove(topic);
                      } else if (_topics.length < 20) {
                        _topics.add(topic);
                      }
                    }),
            ),
        ],
      ),
      AppInputField(
        key: const Key('mentorProfile_customTopic'),
        controller: _customTopic,
        label: context.l10n.mentorshipCustomTopicLabel,
        placeholder: context.l10n.mentorshipCustomTopicHint,
        helperText: context.l10n.mentorshipTopicsLimit,
        enabled: !saving,
        maxLength: 60,
        textInputAction: TextInputAction.done,
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) => _addTopic(),
        trailing: AppIconButton(
          icon: const AppLineIconWidget(AppLineIcon.plus),
          tooltip: context.l10n.add,
          onPressed: saving || !_validTopics || _pendingTopic.isEmpty
              ? null
              : _addTopic,
        ),
      ),
      AppFieldLabel(context.l10n.mentorshipLevelLabel),
      NinjaSegmented<String>(
        value: _level,
        onChanged: saving ? null : (value) => setState(() => _level = value),
        segments: [
          for (final level in levelKeys)
            NinjaSegment(
              value: level,
              label: mentorLevelLabel(context.l10n, level),
            ),
        ],
      ),
      AppFieldLabel(context.l10n.mentorshipFormatLabel),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final format in formatKeys)
            NinjaChip(
              label: mentorFormatLabel(context.l10n, format),
              selected: _formats.contains(format),
              enabled: !saving,
              onTap: () => setState(() {
                if (!_formats.remove(format)) _formats.add(format);
              }),
            ),
        ],
      ),
      AppInputField.multiline(
        label: context.l10n.mentorshipBioLabel,
        controller: _bio,
        minLines: 2,
        maxLines: 4,
        maxLength: 2000,
        enabled: !saving,
        placeholder: context.l10n.mentorshipBioHint,
      ),
      AppButton.primary(
        key: const Key('mentorProfile_save'),
        label: saving
            ? context.l10n.mentorshipSaving
            : context.l10n.mentorshipSave,
        expanded: true,
        size: AppButtonSize.large,
        loading: saving,
        onPressed:
            saving ||
                !_validTopics ||
                !isValidMentorTelegramHandle(_telegram.text)
            ? null
            : () => unawaited(_save()),
      ),
      if (widget.current != null)
        AppButton.text(
          label: context.l10n.mentorshipQuit,
          foregroundColor: context.colors.danger,
          onPressed: saving ? null : () => unawaited(_delete()),
        ),
    ];
    return CustomScrollView(
      key: const Key('mentorProfile_scroll'),
      shrinkWrap: true,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverList.separated(
          itemCount: fields.length,
          itemBuilder: (_, index) => fields[index],
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        ),
      ],
    );
  }
}
