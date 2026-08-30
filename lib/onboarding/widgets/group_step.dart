part of '../view/onboarding_page.dart';

class _GroupStep extends StatefulWidget {
  const _GroupStep({
    required this.initialQuery,
    required this.initialSelected,
    required this.onQueryChanged,
    required this.onSelected,
    required this.onBack,
    required this.onNext,
    super.key,
  });

  final String initialQuery;
  final Group? initialSelected;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<Group> onSelected;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  State<_GroupStep> createState() => _GroupStepState();
}

class _GroupStepState extends State<_GroupStep> {
  late final TextEditingController _controller;
  late final SearchBloc _searchBloc;

  late Group? _selected;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _selected = widget.initialSelected;
    _searchBloc = SearchBloc(
      scheduleRepository: context.read(),
    );
    _controller.addListener(_onQueryChanged);
    if (_controller.text.isNotEmpty) _onQueryChanged();
  }

  void _onQueryChanged() {
    widget.onQueryChanged(_controller.text);
    _searchBloc.add(SearchQueryChanged(searchQuery: _controller.text));
  }

  void _selectGroup(Group group) {
    setState(() => _selected = group);
    widget.onSelected(group);
    context.read<ScheduleBloc>().add(ScheduleRequested(group: group));
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onQueryChanged)
      ..dispose();
    unawaited(_searchBloc.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider.value(
      value: _searchBloc,
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return _OnboardStep(
            step: 1,
            total: 3,
            showBack: true,
            onBack: widget.onBack,
            ctaLabel: l10n.onboardingNext,
            ctaEnabled: _selected != null,
            onCta: widget.onNext,
            child: _GroupStepBody(
              controller: _controller,
              state: state,
              query: _controller.text,
              selected: _selected,
              onSelect: _selectGroup,
            ),
          );
        },
      ),
    );
  }
}
