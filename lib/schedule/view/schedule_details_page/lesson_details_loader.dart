part of '../schedule_details_page.dart';

mixin _LessonDetailsLoader on State<ScheduleDetailsPage> {
  LessonDetailsResponse? _details;
  Object? _loadError;
  bool _loading = true;
  List<GroupMember> _peers = const [];
  TeacherProfile? _teacherProfile;
  int _detailsLoadVersion = 0;
  int _contextRevision = 0;
  int _sourceChangesRevision = 0;
  List<ScheduleChange> _sourceChanges = const [];
  bool _sourceChangesError = false;

  int get _lessonNumber => widget.lesson.lessonBells.number ?? 1;

  List<String> get _streamGroupNames {
    final entities = widget.lesson.groupEntities;
    if (entities != null) return entities.map((group) => group.name).toList();
    return widget.lesson.groups ?? const [];
  }

  void _startDetailsLoad() {
    _contextRevision++;
    unawaited(_loadDetails());
    unawaited(_loadPeers());
    unawaited(_loadTeacherProfile());
    unawaited(_loadSourceChanges());
  }

  @override
  void didUpdateWidget(covariant ScheduleDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lesson == widget.lesson &&
        oldWidget.selectedDate == widget.selectedDate &&
        oldWidget.sourceTeacher == widget.sourceTeacher) {
      return;
    }
    _details = null;
    _peers = const [];
    _teacherProfile = null;
    _sourceChanges = const [];
    _sourceChangesError = false;
    _startDetailsLoad();
  }

  void _onDetailsLoaded(LessonDetailsResponse details);

  Future<void> _loadDetails() async {
    final version = ++_detailsLoadVersion;
    setState(() {
      _loading = true;
      _loadError = null;
    });

    try {
      final details = await context.read<ScheduleRepository>().getLessonDetails(
        subjectName: widget.lesson.subject,
        lessonDate: widget.selectedDate,
        lessonBellsNumber: _lessonNumber,
      );
      if (!mounted || version != _detailsLoadVersion) return;
      setState(() {
        _details = details;
        _onDetailsLoaded(details);
      });
    } on Exception catch (error, st) {
      log(
        'Failed to load lesson details',
        error: error,
        stackTrace: st,
        name: 'ScheduleDetailsPage',
      );
      if (!mounted || version != _detailsLoadVersion) return;
      setState(() => _loadError = error);
    } finally {
      if (mounted && version == _detailsLoadVersion) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _loadPeers() async {
    if (context.read<AccountPersonaCubit?>()?.state.isTeacher == true) return;
    final revision = _contextRevision;
    try {
      final roster = await context.read<FriendsRepository>().getGroupMembers();
      if (!mounted ||
          revision != _contextRevision ||
          context.read<AccountPersonaCubit?>()?.state.isTeacher == true) {
        return;
      }
      final peers = roster.members;
      final others = peers.where((peer) => !peer.isMe).toList()
        ..sort((a, b) {
          if (a.isFriend == b.isFriend) return 0;
          return a.isFriend ? -1 : 1;
        });
      setState(() => _peers = others);
    } on Exception catch (e, st) {
      log(
        'Failed to load lesson peers',
        error: e,
        stackTrace: st,
        name: 'ScheduleDetailsPage',
      );
    }
  }

  Future<void> _loadTeacherProfile() async {
    final teacher = widget.lesson.teachers.firstOrNull;
    if (teacher == null) return;
    final revision = _contextRevision;
    try {
      final profile = await context.read<CampusRepository>().getTeacherProfile(
        teacher.name,
      );
      if (!mounted || revision != _contextRevision) return;
      setState(() => _teacherProfile = profile);
    } on Exception catch (e, st) {
      log(
        'Failed to load teacher profile',
        error: e,
        stackTrace: st,
        name: 'ScheduleDetailsPage',
      );
    }
  }

  Future<void> _loadSourceChanges() async {
    final revision = ++_sourceChangesRevision;
    final teacher = widget.sourceTeacher;
    if (teacher == null) return;
    final target = switch (teacher.uid?.trim()) {
      final String id when id.isNotEmpty => id,
      _ => teacher.name,
    };
    setState(() => _sourceChangesError = false);
    try {
      final changes = await context
          .read<ScheduleRepository>()
          .getScheduleChanges(
            targetType: .teacher,
            target: target,
          );
      if (!mounted || revision != _sourceChangesRevision) return;
      final ordered = [...changes]
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      setState(() => _sourceChanges = ordered);
    } on Exception catch (error, stackTrace) {
      if (!mounted || revision != _sourceChangesRevision) return;
      log(
        'Failed to load source schedule changes',
        error: error,
        stackTrace: stackTrace,
        name: 'ScheduleDetailsPage',
      );
      setState(() => _sourceChangesError = true);
    }
  }
}
