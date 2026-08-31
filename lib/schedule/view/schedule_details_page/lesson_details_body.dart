part of '../schedule_details_page.dart';

class _LessonDetailsBody extends StatelessWidget {
  const _LessonDetailsBody({
    required this.lesson,
    required this.selectedDate,
    required this.details,
    required this.loading,
    required this.loadError,
    required this.reactionBusy,
    required this.peers,
    required this.teacherProfile,
    required this.showGroups,
    required this.onBack,
    required this.onShare,
    required this.onMore,
    required this.onNote,
    required this.onRoute,
    required this.onReactionTap,
    required this.onReviewTap,
    required this.onRetryDetails,
    required this.onOpenMaterials,
  });

  final LessonSchedulePart lesson;
  final DateTime selectedDate;
  final LessonDetailsResponse? details;
  final bool loading;
  final Object? loadError;
  final bool reactionBusy;
  final List<GroupMember> peers;
  final TeacherProfile? teacherProfile;
  final bool showGroups;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onMore;
  final VoidCallback onNote;
  final VoidCallback onRoute;
  final Future<void> Function(String) onReactionTap;
  final VoidCallback onReviewTap;
  final VoidCallback onRetryDetails;
  final VoidCallback onOpenMaterials;

  @override
  Widget build(BuildContext context) {
    final coldLoad = loading && details == null;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        _SubjectTopBar(
          title: lesson.subject,
          onBack: onBack,
          onShare: onShare,
          onMore: onMore,
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 8),
              _SubjectHero(lesson: lesson, selectedDate: selectedDate),
              _LessonProgressCard(lesson: lesson, selectedDate: selectedDate),
              _LessonActionGrid(onNote: onNote, onRoute: onRoute),
              _TeacherCard(lesson: lesson, profile: teacherProfile),
              if (showGroups) _GroupsCard(lesson: lesson),
              _ReactionsSection(
                loading: coldLoad,
                pending: reactionBusy,
                response: details?.reactions,
                reviews: details?.reviews ?? const [],
                onReactionTap: onReactionTap,
                onReviewTap: onReviewTap,
              ),
              _MaterialsPreview(
                loading: coldLoad,
                error: loadError,
                materials: details?.materials ?? const [],
                onRetry: onRetryDetails,
                onOpenAll: onOpenMaterials,
              ),
              if (peers.isNotEmpty) _PeersCard(peers: peers),
              const SizedBox(height: 32),
            ]),
          ),
        ),
      ],
    );
  }
}
