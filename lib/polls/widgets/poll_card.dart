import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/polls/widgets/poll_option_bar.dart';

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

  Poll get _poll => widget.poll;

  bool get _showResults =>
      _poll.hasVoted || _poll.hasEnded || _poll.showResults;

  bool get _canVote => !_poll.hasVoted && !_poll.hasEnded && !widget.pending;

  void _onOptionTap(PollOption option) {
    if (!_canVote) return;
    unawaited(HapticFeedback.lightImpact());
    if (_poll.pollType == .multi) {
      setState(() {
        if (!_selected.remove(option.id)) _selected.add(option.id);
      });
      return;
    }
    widget.onVote([option.id]);
  }

  (String, Color) _status(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    if (_poll.hasEnded) return (l10n.pollsStatusClosed, colors.muted2);
    final expiresAt = _poll.expiresAt;
    if (expiresAt == null) return (l10n.pollsStatusOpen, colors.warn);
    final locale = Localizations.localeOf(context).toString();
    final date = DateFormat('d MMM', locale).format(expiresAt.toLocal());
    return (l10n.pollsStatusUntil(date), colors.warn);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final (statusLabel, statusColor) = _status(context);
    final author = [
      if (_poll.isMine) l10n.pollsAuthorYou else l10n.pollsAuthorCommunity,
      if (_poll.isAnonymous) l10n.pollsTagAnonymous,
      if (_poll.pollType == .quiz) l10n.pollsTagQuiz,
    ].join(' · ');
    final footer = [
      l10n.pollsVotesCount(_poll.totalVotes),
      if (_poll.hasVoted) l10n.pollsYouAnswered,
    ].join(' · ');
    final showVoteButton = _poll.pollType == .multi && !_poll.hasVoted;
    return AppCard(
      radius: AppRadius.row,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.captionStrong.copyWith(color: colors.muted),
                ),
              ),
              const SizedBox(width: AppSpacing.gap),
              Text(
                statusLabel,
                style: AppText.captionStrong.copyWith(color: statusColor),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _poll.question,
            style: AppText.sans(
              16,
              FontWeight.w700,
            ).copyWith(color: colors.ink),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final (index, option) in _poll.options.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.xsm),
            PollOptionBar(
              option: option,
              poll: _poll,
              showResults: _showResults,
              selected: _selected.contains(option.id),
              selectable: _canVote,
              onTap: () => _onOptionTap(option),
            ),
          ],
          if (showVoteButton) ...[
            const SizedBox(height: AppSpacing.md),
            AppButton.primary(
              label: l10n.pollsVote,
              size: AppButtonSize.small,
              expanded: true,
              loading: widget.pending,
              onPressed: _selected.isEmpty || !_canVote
                  ? null
                  : () => widget.onVote(_selected.toList()),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  footer,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.captionStrong.copyWith(color: colors.muted),
                ),
              ),
              if (widget.pending && !showVoteButton) ...[
                const SizedBox(width: AppSpacing.sm),
                AppSpinner(size: 14, strokeWidth: 2, color: colors.accent),
              ],
              if (_poll.isMine) ...[
                const SizedBox(width: AppSpacing.sm),
                AppIconButton(
                  tooltip: l10n.pollsDelete,
                  shape: AppIconButtonShape.circle,
                  size: AppIconButtonSize.small,
                  onPressed: widget.deleting ? null : widget.onDelete,
                  icon: widget.deleting
                      ? AppSpinner(
                          size: 14,
                          strokeWidth: 2,
                          color: colors.muted,
                        )
                      : const AppLineIconWidget(AppLineIcon.trash, size: 17),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
