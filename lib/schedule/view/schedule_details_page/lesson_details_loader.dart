part of '../schedule_details_page.dart';

mixin _LessonDetailsLoader on State<ScheduleDetailsPage> {
  LessonDetailsResponse? _details;
  Object? _loadError;
  bool _loading = true;
  List<GroupMember> _peers = const [];
  TeacherProfile? _teacherProfile;
  int _detailsLoadVersion = 0;

  int get _lessonNumber => widget.lesson.lessonBells.number ?? 1;

  List<String> get _streamGroupNames {
    final entities = widget.lesson.groupEntities;
    if (entities != null) return entities.map((group) => group.name).toList();
    return widget.lesson.groups ?? const [];
  }

  void _startDetailsLoad() {
    unawaited(_loadDetails());
    unawaited(_loadPeers());
    unawaited(_loadTeacherProfile());
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
    try {
      final roster = await context.read<FriendsRepository>().getGroupMembers();
      if (!mounted) return;
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
    try {
      final profile = await context.read<CampusRepository>().getTeacherProfile(
        teacher.name,
      );
      if (!mounted) return;
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
}
