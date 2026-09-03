part of 'profile_page.dart';

const kProfileBottomInset = 130.0;

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Scaffold(
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
                .loading when state.gamificationProfile.isEmpty => ListView(
                  key: const ValueKey('profile-loading'),
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    AppScreenHeader(title: l10n.profile),
                    const ProfileSkeleton(),
                  ],
                ),
                .error when state.gamificationProfile.isEmpty => ListView(
                  key: const ValueKey('profile-error'),
                  padding: EdgeInsets.only(
                    bottom:
                        kProfileBottomInset +
                        MediaQuery.paddingOf(context).bottom,
                  ),
                  children: [
                    AppScreenHeader(
                      title: l10n.profile,
                      actions: [
                        AppHeaderAction(
                          icon: AppLineIcon.tune,
                          semanticsLabel: l10n.settingsTitle,
                          onTap: () =>
                              const ProfileSettingsRoute().push<void>(context),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screen,
                        AppSpacing.xlg,
                        AppSpacing.screen,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (state.user.isGuest) ...[
                            AppBanner(
                              message: l10n.authGuestUpgradeSubtitle,
                              actionLabel: l10n.authGuestUpgradeTitle,
                              onAction: () =>
                                  unawaited(showGuestUpgradeSheet(context)),
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                          ProfileIdentityRow(
                            name:
                                state.overview.academic.fullName ??
                                state.user.name ??
                                l10n.profileStudentFallback,
                            meta: state.overview.academic.group ?? '',
                            onTap: () => showEditProfileSheet(context),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screen,
                        24,
                        AppSpacing.screen,
                        0,
                      ),
                      child: AppErrorState(
                        lineIcon: AppLineIcon.alert,
                        title: l10n.profileLoadErrorTitle,
                        message: l10n.profileLoadErrorMessage,
                        primaryLabel: l10n.retry,
                        onPrimary: () => context.read<ProfileCubit>().load(),
                        footnote: null,
                      ),
                    ),
                  ],
                ),
                .initial || .loading || .loaded || .error => RefreshIndicator(
                  key: const ValueKey('profile-content'),
                  color: colors.accent,
                  backgroundColor: colors.canvas,
                  onRefresh: () => context.read<ProfileCubit>().load(),
                  child: _ProfileBody(state: state),
                ),
              },
            );
          },
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
      final l10n = context.l10n;
      for (final badge in state.newlyEarnedBadges) {
        ToastManager.showSuccess(
          context,
          message: l10n.profileBadgeUnlocked,
          actionLabel: badge.name,
          onAction: () {
            if (context.mounted) openNinjaPath(context);
          },
        );
      }
      context.read<ProfileCubit>().celebrationsShown();
    }
  }
}
