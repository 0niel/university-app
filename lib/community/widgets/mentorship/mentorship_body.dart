import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/mentorship/mentorship.dart';
import 'package:rtu_mirea_app/community/widgets/mentorship/mentor_card.dart';
import 'package:rtu_mirea_app/community/widgets/mentorship/mentor_request_card.dart';
import 'package:rtu_mirea_app/community/widgets/mentorship/mentorship_skeleton.dart';
import 'package:rtu_mirea_app/community/widgets/ninja_section_title.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MentorshipBody extends StatelessWidget {
  const MentorshipBody({
    required this.onEditProfile,
    required this.onRequest,
    required this.onReply,
    required this.onAction,
    super.key,
  });

  final VoidCallback onEditProfile;
  final ValueChanged<Mentor> onRequest;
  final ValueChanged<MentorRequest> onReply;
  final void Function(MentorRequest, MentorRequestAction) onAction;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MentorshipCubit>().state;
    return RefreshIndicator(
      color: context.colors.ink,
      onRefresh: context.read<MentorshipCubit>().load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const .only(top: 14, bottom: 32),
        children: [
          if (!state.isMentor) _profileCta(context, state),
          ..._requests(context, state),
          NinjaStateSwitcher(child: _mentors(context, state)),
        ],
      ),
    );
  }

  Widget _profileCta(BuildContext context, MentorshipState state) {
    final colors = context.colors;
    final title = state.isMentor
        ? context.l10n.mentorshipYouAreMentor
        : context.l10n.mentorshipBecomeCta;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        10,
      ),
      child: AppPressable(
        onTap: onEditProfile,
        semanticsLabel: title,
        semanticsButton: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.tint,
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .55),
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox.square(
                    dimension: 44,
                    child: Center(
                      child: AppNinjaMark(size: 20, color: colors.ink),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppText.headline.copyWith(
                          color: colors.ink,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        state.isMentor
                            ? context.l10n.mentorshipEditHint
                            : context.l10n.mentorshipBecomeHint,
                        style: AppText.captionSmall.copyWith(
                          color: colors.muted,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AppLineIconWidget(
                  .chevronR,
                  size: 16,
                  color: colors.muted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _requests(BuildContext context, MentorshipState state) {
    if (state.requestsStatus == .loading) {
      return const [
        Padding(
          padding: .fromLTRB(
            AppSpacing.screen,
            22,
            AppSpacing.screen,
            0,
          ),
          child: NinjaSkeleton(height: 88, radius: AppRadius.card),
        ),
      ];
    }
    if (state.requestsStatus == .failure) {
      return [
        Padding(
          padding: const .fromLTRB(
            AppSpacing.screen,
            22,
            AppSpacing.screen,
            0,
          ),
          child: NinjaErrorState(
            title: context.l10n.mentorshipRequestsError,
            message: context.l10n.mentorshipRequestsErrorSubtitle,
            retryLabel: context.l10n.retry,
            onRetry: () => unawaited(context.read<MentorshipCubit>().load()),
          ),
        ),
      ];
    }
    if (state.requests.isEmpty) return const [];
    final incoming = state.requests
        .where((request) => request.isIncoming)
        .toList(growable: false);
    final outgoing = state.requests
        .where((request) => !request.isIncoming)
        .toList(growable: false);
    return [
      ..._requestSection(
        state,
        context.l10n.mentorshipRequestsToYou,
        incoming,
      ),
      ..._requestSection(
        state,
        context.l10n.mentorshipOutgoingRequests,
        outgoing,
      ),
    ];
  }

  List<Widget> _requestSection(
    MentorshipState state,
    String title,
    List<MentorRequest> requests,
  ) {
    if (requests.isEmpty) return const [];
    return [
      NinjaSectionTitle(title: title, count: requests.length),
      for (final (index, request) in requests.indexed)
        MentorRequestCard(
          request: request,
          isDismissing: state.pendingRequestIds.contains(request.id),
          onReply: () => onReply(request),
          onAction: (action) => onAction(request, action),
        ).animateListItem(key: ValueKey(request.id), index: index),
    ];
  }

  Widget _mentors(BuildContext context, MentorshipState state) {
    if (state.status == .loading && state.mentors.isEmpty) {
      return const MentorshipSkeleton(key: ValueKey('mentors-loading'));
    }
    if (state.status == .failure && state.mentors.isEmpty) {
      return Padding(
        key: const ValueKey('mentors-failure'),
        padding: const .fromLTRB(
          AppSpacing.screen,
          22,
          AppSpacing.screen,
          0,
        ),
        child: NinjaErrorState(
          title: context.l10n.mentorshipLoadError,
          message: context.l10n.mentorshipLoadErrorSubtitle,
          retryLabel: context.l10n.retry,
          onRetry: () => unawaited(context.read<MentorshipCubit>().load()),
        ),
      );
    }
    if (state.mentors.isEmpty) {
      return Padding(
        key: const ValueKey('mentors-empty'),
        padding: const .fromLTRB(
          AppSpacing.screen,
          22,
          AppSpacing.screen,
          0,
        ),
        child: NinjaEmptyState.screen(
          icon: const AppLineIconWidget(AppLineIcon.people, size: 24),
          title: context.l10n.mentorshipEmptyTitle,
          message: context.l10n.mentorshipEmptySubtitle,
          actionLabel: context.l10n.mentorshipBecomeCta,
          onAction: onEditProfile,
        ).animateEmptyState(),
      );
    }
    return Column(
      key: const ValueKey('mentors-list'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, mentor) in state.mentors.indexed)
          MentorCard(
            mentor: mentor,
            onEdit: mentor.isMe ? onEditProfile : null,
            onRequest: mentor.isMe ? null : () => onRequest(mentor),
          ).animateListItem(key: ValueKey(mentor.userId), index: index),
      ],
    );
  }
}
