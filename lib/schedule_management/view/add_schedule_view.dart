part of 'add_schedule_page.dart';

class AddScheduleView extends StatefulWidget {
  const AddScheduleView({super.key});

  @override
  State<AddScheduleView> createState() => _AddScheduleViewState();
}

class _AddScheduleViewState extends State<AddScheduleView> {
  final TextEditingController _controller = TextEditingController();
  ScheduleTarget _target = .group;
  String _query = '';

  SearchMode get _modeFor => _target == .classroom ? .classrooms : .schedule;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTargetChanged(ScheduleTarget target) {
    if (_target == target) return;
    final previousMode = _modeFor;
    setState(() => _target = target);
    if (_modeFor != previousMode) {
      context.read<SearchBloc>()
        ..add(SearchModeChanged(searchMode: _modeFor))
        ..add(SearchQueryChanged(searchQuery: _controller.text));
    }
  }

  void _onQueryChanged(String query) {
    context.read<SearchBloc>().add(SearchQueryChanged(searchQuery: query));
    setState(() => _query = query);
  }

  String get _hint {
    final l10n = context.l10n;
    return switch (_target) {
      .group => l10n.addScheduleSearchGroupHint,
      .teacher => l10n.addScheduleSearchTeacherHint,
      .classroom => l10n.addScheduleSearchClassroomHint,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            NinjaMetrics.screenPadding,
            4,
            NinjaMetrics.screenPadding,
            14,
          ),
          child: NinjaTabs<ScheduleTarget>(
            value: _target,
            onChanged: _onTargetChanged,
            padding: EdgeInsets.zero,
            spacing: 16,
            tabs: [
              NinjaTab(
                value: ScheduleTarget.group,
                label: l10n.addScheduleTabGroup,
              ),
              NinjaTab(
                value: ScheduleTarget.teacher,
                label: l10n.addScheduleTabTeacher,
              ),
              NinjaTab(
                value: ScheduleTarget.classroom,
                label: l10n.addScheduleTabClassroom,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            NinjaMetrics.screenPadding,
            0,
            NinjaMetrics.screenPadding,
            14,
          ),
          child: NinjaInput(
            controller: _controller,
            autofocus: true,
            leadingIcon: AppLineIconWidget(
              AppLineIcon.search,
              color: context.ninja.muted,
              size: 18,
            ),
            placeholder: _hint,
            onChanged: _onQueryChanged,
          ),
        ),
        Expanded(
          child: _query.trim().isNotEmpty
              ? _AddScheduleResults(target: _target)
              : _ScheduleZeroState(onCreate: () => _openCreate(context)),
        ),
      ],
    );
  }

  void _openCreate(BuildContext context) {
    Navigator.of(context).pop();
    GoRouter.of(context).go('/schedule/create');
  }
}
