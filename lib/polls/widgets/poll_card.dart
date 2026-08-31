import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/polls/utils/utils.dart';

part 'poll_option_row.dart';
part 'poll_share_bar.dart';
part 'poll_tags.dart';
part 'selection_dot.dart';

class PollCard extends StatefulWidget {
  const PollCard({
    required this.poll,
    required this.onVote,
    required this.onDelete,
    this.pending = false,
    this.deleting = false,
    super.key,
  });

  final Poll poll;
  final ValueChanged<List<String>> onVote;
  final VoidCallback onDelete;

  final bool pending;
  final bool deleting;

  @override
  State<PollCard> createState() => _PollCardState();
}

class _PollCardState extends State<PollCard> {
  final _selected = <String>{};

  bool get _showResults {
    final poll = widget.poll;
    return poll.hasVoted || poll.hasEnded || poll.showResults;
  }

  bool get _canVote =>
      !widget.poll.hasVoted && !widget.poll.hasEnded && !widget.pending;

  void _onOptionTap(PollOption option) {
    final poll = widget.poll;
    if (!_canVote) return;
    unawaited(HapticFeedback.lightImpact());
    if (poll.pollType == .multi) {
      setState(() {
        if (_selected.contains(option.id)) {
          _selected.remove(option.id);
        } else {
          _selected.add(option.id);
        }
      });
      return;
    }
    widget.onVote([option.id]);
  }

  void _onVoteButtonTap() {
    unawaited(HapticFeedback.lightImpact());
    widget.onVote(_selected.toList());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final poll = widget.poll;
    final isMulti = poll.pollType == .multi;
    final showResults = _showResults;
    final createdAt = poll.createdAt;
    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            _PollTags(poll: poll),
            Text(
              poll.question,
              style: NinjaText.title.copyWith(color: colors.ink),
            ),
            const SizedBox(height: 12),
            for (final option in poll.options) ...[
              _PollOptionRow(
                option: option,
                poll: poll,
                showResults: showResults,
                selected: _selected.contains(option.id),
                selectable: _canVote,
                onTap: () => _onOptionTap(option),
              ),
              const SizedBox(height: 8),
            ],
            if (isMulti && (_canVote || widget.pending)) ...[
              const SizedBox(height: 2),
              NinjaButton.primary(
                label: l10n.pollsVote,
                expanded: true,
                loading: widget.pending,
                onPressed: (_selected.isEmpty || widget.pending)
                    ? null
                    : _onVoteButtonTap,
              ),
              const SizedBox(height: 6),
            ],
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    [
                      l10n.pollsVotesCount(poll.totalVotes),
                      if (createdAt != null) relativeTime(l10n, createdAt),
                    ].join(' · '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: NinjaText.subtext.copyWith(color: colors.muted),
                  ),
                ),
                if (!isMulti && widget.pending) ...[
                  const SizedBox(width: 8),
                  NinjaSpinner(size: 12, color: colors.ink),
                ],
                const SizedBox(width: 8),
                if (poll.isMine)
                  NinjaIconButton(
                    tooltip: l10n.pollsDelete,
                    onPressed: widget.deleting ? null : widget.onDelete,
                    icon: widget.deleting
                        ? NinjaSpinner(size: 16, color: colors.muted)
                        : AppLineIconWidget(
                            AppLineIcon.trash,
                            size: 20,
                            color: colors.muted,
                          ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
    return card;
  }
}
