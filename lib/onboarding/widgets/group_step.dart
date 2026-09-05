import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/widgets/widgets.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/onboarding/widgets/group_results.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';
import 'package:schedule_repository/schedule_repository.dart';

class OnboardingGroupStep extends StatefulWidget {
  const OnboardingGroupStep({
    required this.step,
    required this.totalSteps,
    required this.initialQuery,
    required this.initialSelected,
    required this.onQueryChanged,
    required this.onSelected,
    required this.onBack,
    required this.onNext,
    this.onSkip,
    this.onCreateSchedule,
    super.key,
  });

  final int step;
  final int totalSteps;
  final String initialQuery;
  final Group? initialSelected;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<Group?> onSelected;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback? onSkip;
  final VoidCallback? onCreateSchedule;

  @override
  State<OnboardingGroupStep> createState() => _OnboardingGroupStepState();
}

class _OnboardingGroupStepState extends State<OnboardingGroupStep> {
  late final TextEditingController _controller;
  late final SearchBloc _searchBloc;
  Group? _selected;
  var _edited = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _selected = widget.initialSelected;
    _searchBloc = SearchBloc(scheduleRepository: context.read());
    _controller.addListener(_onQueryChanged);
    if (_controller.text.isNotEmpty) _search();
  }

  @override
  void didUpdateWidget(covariant OnboardingGroupStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_edited) return;
    _selected = widget.initialSelected;
    if (_controller.text != widget.initialQuery) {
      _controller
        ..removeListener(_onQueryChanged)
        ..text = widget.initialQuery
        ..addListener(_onQueryChanged);
      _search();
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onQueryChanged)
      ..dispose();
    unawaited(_searchBloc.close());
    super.dispose();
  }

  void _search() =>
      _searchBloc.add(SearchQueryChanged(searchQuery: _controller.text));

  void _onQueryChanged() {
    _edited = true;
    widget.onQueryChanged(_controller.text);
    final selected = _selected;
    if (selected != null && selected.name != _controller.text.trim()) {
      setState(() => _selected = null);
      widget.onSelected(null);
    } else {
      setState(() {});
    }
    _search();
  }

  void _select(Group group) {
    _edited = true;
    setState(() => _selected = group);
    widget.onSelected(group);
    context.read<ScheduleBloc>().add(ScheduleRequested(group: group));
  }

  Color _fieldColor(AppColors colors) {
    if (_selected != null) return colors.lectureTint;
    if (_controller.text.trim().isNotEmpty) return colors.tint;
    return colors.surface;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return BlocProvider.value(
      value: _searchBloc,
      child: AuthPageLayout(
        step: widget.step,
        totalSteps: widget.totalSteps,
        title: l10n.onboardingGroupTitle,
        subtitle: l10n.onboardingGroupLead,
        onBack: widget.onBack,
        actions: AppButton.primary(
          key: const Key('onboarding_groupContinue'),
          label: l10n.onboardingContinue,
          size: AppButtonSize.hero,
          expanded: true,
          backgroundColor: _selected == null ? colors.surface2 : null,
          onPressed: _selected == null ? null : widget.onNext,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppInputField(
              key: const Key('onboarding_groupSearch'),
              controller: _controller,
              placeholder: l10n.onboardingGroupPlaceholder,
              leadingIcon: AppLineIcon.search,
              height: 54,
              fillColor: _fieldColor(colors),
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.search,
              textStyle: AppText.sans(16, FontWeight.w500),
            ),
            const SizedBox(height: 12),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) => GroupResults(
                state: state,
                query: _controller.text,
                selected: _selected,
                onSelect: _select,
                onRetry: _search,
                onCreateSchedule:
                    widget.onCreateSchedule ??
                    () => const ScheduleCreateRoute().push<void>(context),
              ),
            ),
            if (widget.onSkip != null) ...[
              const SizedBox(height: AppSpacing.md),
              AppButton.text(
                key: const Key('onboarding_skip'),
                label: l10n.onboardingSkip,
                expanded: true,
                foregroundColor: colors.muted,
                onPressed: widget.onSkip,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
