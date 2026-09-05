import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';
import 'package:rtu_mirea_app/community/cubit/mentorship/mentorship.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/community/view/mentorship_labels.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MentorRequestSheet extends StatefulWidget {
  const MentorRequestSheet({required this.mentor, super.key});

  final Mentor mentor;

  @override
  State<MentorRequestSheet> createState() => _MentorRequestSheetState();
}

class _MentorRequestSheetState extends State<MentorRequestSheet> {
  final _message = TextEditingController();
  late String _topic = widget.mentor.topics.firstOrNull ?? '';
  late MentorWhenSlot _whenSlot = _slotFor(
    UniversityConfig.current.mentorWhenSlotKeys.firstOrNull ??
        MentorWhenSlot.week.wireValue,
  );
  var _failed = false;
  var _submitting = false;

  MentorWhenSlot _slotFor(String key) =>
      MentorWhenSlot.values.firstWhereOrNull((slot) => slot.wireValue == key) ??
      .week;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_submitting ||
        _topic.isEmpty ||
        context.read<MentorshipCubit>().state.pendingMentorIds.contains(
          widget.mentor.userId,
        )) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _failed = false;
      _submitting = true;
    });
    final sent = await context.read<MentorshipCubit>().sendRequest(
      MentorRequestDraft(
        mentorUserId: widget.mentor.userId,
        topic: _topic,
        whenSlot: _whenSlot,
        message: _message.text,
      ),
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (sent) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateSending = context.select<MentorshipCubit, bool>(
      (cubit) => cubit.state.pendingMentorIds.contains(widget.mentor.userId),
    );
    final sending = stateSending || _submitting;
    final slotKeys = UniversityConfig.current.mentorWhenSlotKeys;
    final fields = <Widget>[
      if (_failed)
        AppBanner(
          message: context.l10n.mentorshipRequestError,
          tone: .danger,
        ),
      _mentorSummary(context),
      AppFieldLabel(context.l10n.mentorshipTopicLabel),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final topic in widget.mentor.topics)
            NinjaChip(
              label: mentorTopicLabel(context.l10n, topic),
              selected: _topic == topic,
              enabled: !sending,
              onTap: () => setState(() => _topic = topic),
            ),
        ],
      ),
      AppFieldLabel(context.l10n.mentorshipWhenLabel),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final slotKey in slotKeys)
            NinjaChip(
              label: mentorWhenLabel(context.l10n, slotKey),
              selected: _whenSlot == _slotFor(slotKey),
              enabled: !sending,
              onTap: sending
                  ? null
                  : () => setState(() => _whenSlot = _slotFor(slotKey)),
            ),
        ],
      ),
      AppInputField.multiline(
        label: context.l10n.mentorshipMessageLabel,
        controller: _message,
        minLines: 2,
        maxLines: 4,
        maxLength: 2000,
        enabled: !sending,
        placeholder: context.l10n.mentorshipMessageHint,
      ),
      AppButton.primary(
        key: const Key('mentorRequest_send'),
        label: sending
            ? context.l10n.teamFinderSending
            : context.l10n.mentorshipSendRequest,
        expanded: true,
        size: AppButtonSize.large,
        loading: sending,
        onPressed: sending || _topic.isEmpty ? null : () => unawaited(_send()),
      ),
    ];
    return CustomScrollView(
      key: const Key('mentorRequest_scroll'),
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

  Widget _mentorSummary(BuildContext context) {
    return AppListGroup(
      children: [
        AppListRow(
          title: widget.mentor.fullName,
          subtitle: widget.mentor.bio.isEmpty ? null : widget.mentor.bio,
          leading: NinjaAvatar(
            initials: ninjaInitials(widget.mentor.fullName),
            size: 42,
          ),
        ),
      ],
    );
  }
}
