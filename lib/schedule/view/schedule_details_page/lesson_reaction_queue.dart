part of '../schedule_details_page.dart';

mixin _LessonReactionQueue on _LessonDetailsLoader {
  Future<void> _reactionOperations = Future.value();
  int _reactionBusyCount = 0;
  String? _queuedUserReaction;

  bool get _reactionBusy => _reactionBusyCount > 0;

  @override
  void _onDetailsLoaded(LessonDetailsResponse details) {
    _queuedUserReaction = details.reactions.userReaction;
  }

  Future<void> _toggleReaction(String reaction) {
    if (!mounted) return Future.value();
    setState(() => _reactionBusyCount++);
    final result = _reactionOperations.then(
      (_) => _performReactionToggle(reaction),
    );
    _reactionOperations = result.then<void>(
      (_) => null,
      onError: (Object _, StackTrace _) => null,
    );
    return result.whenComplete(() {
      if (mounted) setState(() => _reactionBusyCount--);
    });
  }

  Future<void> _performReactionToggle(String reaction) async {
    if (!mounted) return;
    final repository = context.read<ScheduleRepository>();
    final current = _queuedUserReaction;

    try {
      if (current == reaction) {
        await repository.deleteLessonReaction(
          subjectName: widget.lesson.subject,
          lessonDate: widget.selectedDate,
          lessonBellsNumber: _lessonNumber,
        );
        _queuedUserReaction = null;
      } else {
        await repository.postLessonReaction(
          subjectName: widget.lesson.subject,
          lessonDate: widget.selectedDate,
          lessonBellsNumber: _lessonNumber,
          reactionType: reaction,
        );
        _queuedUserReaction = reaction;
      }
      if (!mounted) return;
      await _loadDetails();
      unawaited(_playReactionHaptic());
    } on Exception catch (e, st) {
      log(
        'Failed to toggle lesson reaction',
        error: e,
        stackTrace: st,
        name: 'ScheduleDetailsPage',
      );
      if (!mounted) return;
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.lessonDetailsSignInReact,
      );
    }
  }

  Future<void> _playReactionHaptic() async {
    try {
      await HapticFeedback.selectionClick();
    } on PlatformException catch (error, stackTrace) {
      log(
        'Reaction haptic feedback is unavailable',
        error: error,
        stackTrace: stackTrace,
        name: 'ScheduleDetailsPage',
      );
    }
  }
}
