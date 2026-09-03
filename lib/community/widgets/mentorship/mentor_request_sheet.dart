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
import 'package:rtu_mirea_app/community/widgets/mentorship/mentorship_choice_chip.dart';
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

  MentorWhenSlot _slotFor(String key) =>
      MentorWhenSlot.values.firstWhereOrNull((slot) => slot.wireValue == key) ??
      .week;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() => _failed = false);
    final sent = await context.read<MentorshipCubit>().sendRequest(
      MentorRequestDraft(
        mentorUserId: widget.mentor.userId,
        topic: _topic,
        whenSlot: _whenSlot,
        message: _message.text,
      ),
    );
    if (!mounted) return;
    if (sent) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sending = context.select<MentorshipCubit, bool>(
      (cubit) => cubit.state.pendingMentorIds.contains(widget.mentor.userId),
    );
    final slotKeys = UniversityConfig.current.mentorWhenSlotKeys;
    return SingleChildScrollView(
      child: Column(
        spacing: 16,
        crossAxisAlignment: .start,
        children: [
          if (_failed)
            AppBanner(
              message: context.l10n.mentorshipRequestError,
              tone: .danger,
            ),
          _mentorSummary(context),
          _label(context, context.l10n.mentorshipTopicLabel),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final topic in widget.mentor.topics)
                MentorshipChoiceChip(
                  label: topic,
                  selected: _topic == topic,
                  onPressed: () => setState(() => _topic = topic),
                ),
            ],
          ),
          _label(context, context.l10n.mentorshipWhenLabel),
          Column(
            children: [
              for (final (index, slotKey) in slotKeys.indexed)
                AppRadioRow(
                  title: mentorWhenLabel(context.l10n, slotKey),
                  subtitle: slotKey == 'tonight'
                      ? context.l10n.mentorshipWhenTonightHint
                      : null,
                  selected: _whenSlot == _slotFor(slotKey),
                  isFirst: index == 0,
                  onTap: sending
                      ? null
                      : () => setState(() => _whenSlot = _slotFor(slotKey)),
                ),
            ],
          ),
          _label(context, context.l10n.mentorshipMessageLabel),
          NinjaInput.multiline(
            controller: _message,
            minLines: 2,
            maxLines: 4,
            maxLength: 2000,
            enabled: !sending,
            placeholder: context.l10n.mentorshipMessageHint,
          ),
          _priceHint(context),
          NinjaButton.primary(
            label: sending
                ? context.l10n.teamFinderSending
                : context.l10n.mentorshipSendRequest,
            expanded: true,
            size: NinjaButtonSize.large,
            loading: sending,
            onPressed: sending || _topic.isEmpty
                ? null
                : () => unawaited(_send()),
          ),
        ],
      ),
    );
  }

  Widget _mentorSummary(BuildContext context) {
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      child: Row(
        spacing: 12,
        children: [
          NinjaAvatar(
            initials: ninjaInitials(widget.mentor.fullName),
            size: 42,
          ),
          Expanded(
            child: Text(
              widget.mentor.fullName,
              style: AppText.body.copyWith(color: context.colors.ink),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceHint(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      child: Text(
        widget.mentor.price == 0
            ? context.l10n.mentorshipFreeSession
            : context.l10n.mentorshipPaidSession(widget.mentor.price),
        style: AppText.captionSmall.copyWith(color: colors.muted),
      ),
    );
  }

  Widget _label(BuildContext context, String label) => Text(
    label,
    style: AppText.captionSmall.copyWith(color: context.colors.muted),
  );
}
