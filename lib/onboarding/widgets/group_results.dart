import 'package:app_ui/app_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/onboarding/widgets/group_result_row.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';
import 'package:schedule_repository/schedule_repository.dart';

class GroupResults extends StatelessWidget {
  const GroupResults({
    required this.state,
    required this.query,
    required this.selected,
    required this.onSelect,
    required this.onRetry,
    required this.onCreateSchedule,
    super.key,
  });

  final SearchState state;
  final String query;
  final Group? selected;
  final ValueChanged<Group> onSelect;
  final VoidCallback onRetry;
  final VoidCallback onCreateSchedule;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final results = state.groups.results;
    final hasQuery = query.trim().isNotEmpty;
    return NinjaStateSwitcher(
      child: switch (state.status) {
        SearchStatus.loading => const _GroupResultsSkeleton(
          key: ValueKey('onboarding_groups_loading'),
        ),
        SearchStatus.failure => NinjaErrorState(
          key: const ValueKey('onboarding_groups_failure'),
          title: l10n.loadingError,
          message: l10n.tryAgain,
          retryLabel: l10n.retry,
          onRetry: onRetry,
        ),
        _ when results.isNotEmpty => _GroupResultsCard(
          key: const ValueKey('onboarding_groups_results'),
          children: [
            for (var index = 0; index < results.length; index++) ...[
              if (index != 0) const AppDivider(),
              GroupResultRow(
                group: results[index],
                selected: results[index] == selected,
                onTap: () => onSelect(results[index]),
              ),
            ],
          ],
        ),
        _ when hasQuery => _GroupResultsCard(
          key: const ValueKey('onboarding_groups_empty'),
          children: [GroupNotFound(onCreateSchedule: onCreateSchedule)],
        ),
        _ => _GroupResultsCard(
          key: const ValueKey('onboarding_groups_idle'),
          children: [_GroupsHint(text: l10n.onboardingGroupHint)],
        ),
      },
    );
  }
}

class _GroupResultsCard extends StatelessWidget {
  const _GroupResultsCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.row),
      child: DecoratedBox(
        decoration: BoxDecoration(color: context.colors.surface),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

class _GroupResultsSkeleton extends StatelessWidget {
  const _GroupResultsSkeleton({super.key});

  static const _widthFactors = [0.42, 0.36, 0.48, 0.4];

  @override
  Widget build(BuildContext context) {
    return AppSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: _GroupResultsCard(
        children: [
          for (var index = 0; index < _widthFactors.length; index++) ...[
            if (index != 0) const AppDivider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 15, 18, 15),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 20,
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: AppSkeleton.bar(
                          height: 14,
                          widthFactor: _widthFactors[index],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const AppSkeleton.avatar(size: 22),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _GroupsHint extends StatelessWidget {
  const _GroupsHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppText.sans(
          14,
          FontWeight.w500,
          height: 1.45,
        ).copyWith(color: context.colors.muted),
      ),
    );
  }
}

class GroupNotFound extends StatefulWidget {
  const GroupNotFound({required this.onCreateSchedule, super.key});

  final VoidCallback onCreateSchedule;

  @override
  State<GroupNotFound> createState() => _GroupNotFoundState();
}

class _GroupNotFoundState extends State<GroupNotFound> {
  late final TapGestureRecognizer _recognizer = TapGestureRecognizer()
    ..onTap = () => widget.onCreateSchedule();

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final base = AppText.sans(
      14,
      FontWeight.w500,
      height: 1.45,
    ).copyWith(color: colors.muted);
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
      child: Text.rich(
        TextSpan(
          style: base,
          children: [
            TextSpan(text: l10n.onboardingGroupNotFound),
            TextSpan(
              text: l10n.onboardingGroupNotFoundAction,
              recognizer: _recognizer,
              style: base.copyWith(
                color: colors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(text: l10n.onboardingGroupNotFoundSuffix),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
