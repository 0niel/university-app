part of 'profile_page.dart';

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return NinjaToastHost(
      child: Scaffold(
        backgroundColor: colors.canvas,
        body: BlocListener<ProfileCubit, ProfileState>(
          listenWhen: (previous, current) {
            final badgesChanged =
                current.newlyEarnedBadges.isNotEmpty &&
                !listEquals(
                  previous.newlyEarnedBadges,
                  current.newlyEarnedBadges,
                );
            final settingsArrived =
                current.status == .loaded && previous.status != .loaded;
            final accentChanged =
                previous.settings.accentColor != current.settings.accentColor;
            return badgesChanged || settingsArrived || accentChanged;
          },
          listener: _onProfileChanged,
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return NinjaStateSwitcher(
                child: switch (state.status) {
                  .loading when state.gamificationProfile.isEmpty =>
                    const _ProfileSkeleton(key: ValueKey('profile-loading')),
                  .error when state.gamificationProfile.isEmpty => SafeArea(
                    key: const ValueKey('profile-error'),
                    child: Center(
                      child: Padding(
                        padding: const .all(NinjaMetrics.screenPadding),
                        child: NinjaErrorState(
                          title: l10n.profileLoadErrorTitle,
                          message: l10n.profileLoadErrorMessage,
                          retryLabel: l10n.retry,
                          onRetry: () => context.read<ProfileCubit>().load(),
                        ),
                      ),
                    ),
                  ),
                  .initial || .loading || .loaded || .error => RefreshIndicator(
                    key: const ValueKey('profile-content'),
                    color: colors.brand,
                    backgroundColor: colors.canvas,
                    onRefresh: () => context.read<ProfileCubit>().load(),
                    child: _ProfileBody(state: state),
                  ),
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _onProfileChanged(BuildContext context, ProfileState state) {
    if (!state.failedSections.contains(ProfileSection.settings)) {
      final scheme = AppColorScheme.values.firstWhereOrNull(
        (candidate) => candidate.name == state.settings.accentColor,
      );
      if (scheme != null) {
        context.read<ThemeCubit?>()?.setColorScheme(scheme);
      }
    }
    if (state.newlyEarnedBadges.isNotEmpty) {
      _celebrateNewBadges(context, state);
    }
  }

  void _celebrateNewBadges(BuildContext context, ProfileState state) {
    final l10n = context.l10n;
    for (final badge in state.newlyEarnedBadges) {
      showNinjaToast(
        context,
        message: l10n.profileBadgeUnlocked,
        actionLabel: badge.name,
        onAction: () {
          if (context.mounted) _openNinjaPath(context);
        },
      );
    }
    context.read<ProfileCubit>().celebrationsShown();
  }
}
