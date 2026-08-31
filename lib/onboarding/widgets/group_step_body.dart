part of '../view/onboarding_page.dart';

class _GroupStepBody extends StatelessWidget {
  const _GroupStepBody({
    required this.controller,
    required this.state,
    required this.query,
    required this.selected,
    required this.onSelect,
  });

  final TextEditingController controller;
  final SearchState state;
  final String query;
  final Group? selected;
  final ValueChanged<Group> onSelect;

  Widget _results(BuildContext context, AppLocalizations l10n) {
    final results = state.groups.results;
    if (state.status == .loading) {
      return const _GroupResultsSkeleton(key: ValueKey('loading'));
    }
    if (state.status == .failure) {
      return NinjaErrorState(
        key: const ValueKey('failure'),
        title: l10n.loadingError,
        message: l10n.tryAgain,
        retryLabel: l10n.retry,
        onRetry: () => context.read<SearchBloc>().add(
          SearchQueryChanged(searchQuery: query),
        ),
      );
    }
    if (results.isEmpty) {
      if (query.trim().isEmpty) {
        return const SizedBox.shrink(key: ValueKey('idle'));
      }
      return NinjaEmptyState(
        key: const ValueKey('empty'),
        title: l10n.onboardingGroupEmpty,
        message: l10n.onboardingGroupHint,
        icon: const NinjaGlyphIcon(NinjaGlyph.search),
        actionLabel: l10n.clear,
        onAction: controller.clear,
      ).animateEmptyState();
    }
    return Column(
      key: const ValueKey('results'),
      crossAxisAlignment: .stretch,
      children: [
        for (var index = 0; index < results.length; index++) ...[
          if (index != 0) const SizedBox(height: 10),
          _GroupResultRow(
            group: results[index],
            selected: results[index] == selected,
            onTap: () => onSelect(results[index]),
          ).animateListItem(index: index),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        const _OnboardingLeadIcon(AppLineIcon.people),
        const SizedBox(height: 18),
        Text(
          l10n.onboardingGroupTitle,
          style: NinjaText.title.copyWith(color: colors.ink),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.onboardingGroupHint,
          style: NinjaText.body.copyWith(color: colors.mutedDark),
        ),
        const SizedBox(height: 22),
        _GroupSearchField(controller: controller),
        const SizedBox(height: 14),
        NinjaStateSwitcher(child: _results(context, l10n)),
      ],
    );
  }
}
