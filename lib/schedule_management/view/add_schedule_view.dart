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
      context.read<SearchBloc>().add(SearchModeChanged(searchMode: _modeFor));
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
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
            child: AppInnerHeader(
              title: l10n.addScheduleTitle,
              onBack: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              0,
              AppSpacing.screen,
              14,
            ),
            child: AppSegmentedControl<ScheduleTarget>(
              value: _target,
              onChanged: _onTargetChanged,
              onCanvas: true,
              options: [
                AppSegmentedOption(
                  value: ScheduleTarget.group,
                  label: l10n.addScheduleTabGroup,
                ),
                AppSegmentedOption(
                  value: ScheduleTarget.teacher,
                  label: l10n.addScheduleTabTeacher,
                ),
                AppSegmentedOption(
                  value: ScheduleTarget.classroom,
                  label: l10n.addScheduleTabClassroom,
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              0,
              AppSpacing.screen,
              14,
            ),
            child: AppSearchField(
              controller: _controller,
              autofocus: true,
              onCanvas: true,
              hintText: _hint,
              onChanged: _onQueryChanged,
            ),
          ),
        ),
      ],
      body: _query.trim().isNotEmpty
          ? _AddScheduleResults(
              target: _target,
              onRetry: () => _onQueryChanged(_controller.text),
            )
          : _ScheduleZeroState(onCreate: () => _openCreate(context)),
    );
  }

  void _openCreate(BuildContext context) {
    Navigator.of(context).pop();
    GoRouter.of(context).go('/schedule/create');
  }
}
