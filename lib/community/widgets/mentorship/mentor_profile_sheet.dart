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
  late final Set<String> _topics = {...?widget.current?.topics};
  late final Set<String> _formats = {...?widget.current?.formats};
  late String _level = _initialLevel;
  late int _price = widget.current?.price ?? 0;

  String get _initialLevel {
    final current = widget.current?.level.trim() ?? '';
    return current.isEmpty
        ? (UniversityConfig.current.mentorLevelKeys.firstOrNull ?? '')
        : current;
  }

  @override
  void dispose() {
    _bio.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final saved = await context.read<MentorshipCubit>().saveProfile(
      MentorProfileDraft(
        topics: _topics.toList(growable: false),
        bio: _bio.text,
        level: _level,
        formats: _formats.toList(growable: false),
        price: _price,
      ),
    );
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop();
    } else {
      _showError(context.l10n.mentorshipProfileSaveError);
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

  @override
  Widget build(BuildContext context) {
    final config = UniversityConfig.current;
    final saving = context.select<MentorshipCubit, bool>(
      (cubit) => cubit.state.isSavingProfile,
    );
    final topicKeys = {...config.mentorTopicKeys, ..._topics};
    final levelKeys = {...config.mentorLevelKeys, _level};
    final formatKeys = {...config.mentorFormatKeys, ..._formats};
    return SingleChildScrollView(
      child: Column(
        spacing: 16,
        crossAxisAlignment: .start,
        children: [
          _reward(context),
          _label(context, context.l10n.mentorshipTopicsLabel),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final topic in topicKeys)
                NinjaChip(
                  label: mentorTopicLabel(context.l10n, topic),
                  selected: _topics.contains(topic),
                  enabled: !saving,
                  onTap: saving
                      ? null
                      : () => setState(() {
                          if (_topics.contains(topic)) {
                            _topics.remove(topic);
                          } else {
                            _topics.add(topic);
                          }
                        }),
                ),
            ],
          ),
          _label(context, context.l10n.mentorshipLevelLabel),
          NinjaSegmented<String>(
            value: _level,
            onChanged: saving
                ? null
                : (value) => setState(() => _level = value),
            segments: [
              for (final level in levelKeys)
                NinjaSegment(
                  value: level,
                  label: mentorLevelLabel(context.l10n, level),
                ),
            ],
          ),
          _label(context, context.l10n.mentorshipFormatLabel),
          for (final format in formatKeys)
            NinjaListCell(
              title: mentorFormatLabel(context.l10n, format),
              horizontalPadding: 0,
              showChevron: false,
              trailing: NinjaSwitch(
                value: _formats.contains(format),
                onChanged: saving
                    ? null
                    : (selected) => setState(
                        () => selected
                            ? _formats.add(format)
                            : _formats.remove(format),
                      ),
              ),
            ),
          _priceSelector(context, saving: saving),
          NinjaInput.multiline(
            controller: _bio,
            minLines: 2,
            maxLines: 4,
            maxLength: 2000,
            enabled: !saving,
            placeholder: context.l10n.mentorshipBioHint,
          ),
          NinjaButton.primary(
            label: saving
                ? context.l10n.mentorshipSaving
                : context.l10n.mentorshipSave,
            expanded: true,
            size: NinjaButtonSize.large,
            onPressed: saving || _topics.isEmpty
                ? null
                : () => unawaited(_save()),
          ),
          if (widget.current != null)
            NinjaButton.destructive(
              label: context.l10n.mentorshipQuit,
              expanded: true,
              onPressed: saving ? null : () => unawaited(_delete()),
            ),
        ],
      ),
    );
  }

  Widget _reward(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      child: Row(
        spacing: 12,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.tint,
              borderRadius: .circular(AppRadius.field),
            ),
            child: SizedBox.square(
              dimension: 44,
              child: Center(
                child: AppNinjaMark(size: 20, color: colors.accent),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  context.l10n.mentorshipRewardTitle,
                  style: AppText.body.copyWith(
                    color: context.colors.ink,
                  ),
                ),
                Text(
                  context.l10n.mentorshipRewardSubtitle,
                  style: AppText.captionSmall.copyWith(
                    color: context.colors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(BuildContext context, String label) => Text(
    label,
    style: AppText.captionSmall.copyWith(color: context.colors.muted),
  );

  Widget _priceSelector(BuildContext context, {required bool saving}) {
    return Container(
      padding: const .symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: .circular(AppRadius.field),
      ),
      child: Row(
        spacing: 4,
        children: [
          Expanded(
            child: Text(
              context.l10n.mentorshipPriceTitle,
              style: AppText.body.copyWith(color: context.colors.ink),
            ),
          ),
          NinjaIconButton(
            tooltip: context.l10n.mentorshipDecreasePrice,
            onPressed: saving || _price == 0
                ? null
                : () => setState(() => _price = (_price - 20).clamp(0, 500)),
            icon: const AppLineIconWidget(.minus, size: 16),
          ),
          SizedBox(
            width: 56,
            child: Text(
              '$_price',
              textAlign: .center,
              style: AppText.tabular(AppText.body),
            ),
          ),
          NinjaIconButton(
            tooltip: context.l10n.mentorshipIncreasePrice,
            onPressed: saving || _price == 500
                ? null
                : () => setState(() => _price = (_price + 20).clamp(0, 500)),
            icon: const AppLineIconWidget(.plus, size: 16),
          ),
        ],
      ),
    );
  }
}
