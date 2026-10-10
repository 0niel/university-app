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
    required this.onUploadMaterial,
    required this.onRemind,
    this.sourceChanges,
    this.sourceChangesError = false,
    this.onRetrySourceChanges,
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
  final VoidCallback onUploadMaterial;
  final VoidCallback onRemind;
  final List<ScheduleChange>? sourceChanges;
  final bool sourceChangesError;
  final VoidCallback? onRetrySourceChanges;

  @override
  Widget build(BuildContext context) {
    final coldLoad = loading && details == null;
    final source = sourceChanges;
    final change = source != null
        ? _sourceLessonChange(source, lesson, selectedDate)
        : changeFor(
            changesForSelectedLesson(
              context.watch<ScheduleChangesCubit?>(),
              context.watch<ScheduleBloc?>()?.state.selectedSchedule,
              lesson,
            ),
            lesson,
            selectedDate,
          );

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        _SubjectTopBar(
          title: lesson.subject,
          onBack: onBack,
          onShare: onShare,
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: AppSpacing.sm),
              if (sourceChangesError)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.zero,
                    AppSpacing.screen,
                    AppSpacing.lg,
                  ),
                  child: AppErrorState(
                    key: const ValueKey('teacher-lesson-changes-error'),
                    title: context.l10n.scheduleChanges,
                    message: context.l10n.loadingError,
                    primaryLabel: context.l10n.retry,
                    onPrimary: onRetrySourceChanges,
                    footnote: null,
                  ),
                ),
              if (isCancelled(change) || isMoved(change))
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.zero,
                    AppSpacing.screen,
                    AppSpacing.lg,
                  ),
                  child: AppBanner(
                    message: isCancelled(change)
                        ? context.l10n.lessonCancelledBanner
                        : context.l10n.lessonMovedBanner(
                            change!.oldValue.rooms.join(', '),
                            change.newValue.rooms.join(', '),
                          ),
                    tone: isCancelled(change)
                        ? AppBannerTone.danger
                        : AppBannerTone.warn,
                  ),
                ),
              _SubjectHero(lesson: lesson, selectedDate: selectedDate),
              _TeacherCard(lesson: lesson, profile: teacherProfile),
              _LessonProgressCard(lesson: lesson, selectedDate: selectedDate),
              _LessonActionGrid(
                onNote: onNote,
                onRoute: onRoute,
                onRemind: onRemind,
                onMaterials: onOpenMaterials,
                lesson: lesson,
                day: selectedDate,
              ),
              if (showGroups) _GroupsCard(lesson: lesson),
              _MaterialsPreview(
                loading: coldLoad,
                error: loadError,
                materials: details?.materials ?? const [],
                onRetry: onRetryDetails,
                onOpenAll: onOpenMaterials,
                onUpload: onUploadMaterial,
              ),
              _ReactionsSection(
                loading: coldLoad,
                pending: reactionBusy,
                response: details?.reactions,
                reviews: details?.reviews ?? const [],
                onReactionTap: onReactionTap,
                onReviewTap: onReviewTap,
              ),
              _GroupNoteCard(lesson: lesson, day: selectedDate, onTap: onNote),
              if (peers.isNotEmpty &&
                  context.watch<AccountPersonaCubit?>()?.state.isTeacher !=
                      true)
                _PeersCard(peers: peers),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screen,
                ),
                child: AppButton.text(
                  label: context.l10n.lessonDetailsAddToSchedule,
                  onPressed: onMore,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ]),
          ),
        ),
      ],
    );
  }
}

ScheduleChange? _sourceLessonChange(
  List<ScheduleChange> changes,
  LessonSchedulePart lesson,
  DateTime day,
) {
  final start = lesson.lessonBells.startTime;
  final slot =
      '${start.hour.toString().padLeft(2, '0')}:'
      '${start.minute.toString().padLeft(2, '0')}';
  String? time(String? value) {
    final parts = value?.split(':');
    if (parts == null || parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
  }

  final matching = changes.where((change) {
    if (change.kind == .add ||
        change.lessonDate.year != day.year ||
        change.lessonDate.month != day.month ||
        change.lessonDate.day != day.day ||
        change.subject.trim().toLowerCase() !=
            lesson.subject.trim().toLowerCase()) {
      return false;
    }
    if (change.oldValue.start != null || change.newValue.start != null) {
      return time(change.oldValue.start) == slot ||
          time(change.newValue.start) == slot;
    }
    return change.lessonNumber != null &&
        change.lessonNumber == lesson.lessonBells.number;
  }).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return matching.firstOrNull;
}
