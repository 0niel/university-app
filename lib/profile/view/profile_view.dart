part of 'profile_page.dart';

const kProfileBottomInset = 130.0;

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final isTeacher =
        context.watch<AccountPersonaCubit?>()?.state.isTeacher ?? false;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: AppAmbientBackground(
        child: BlocListener<ProfileCubit, ProfileState>(
          listenWhen: (previous, current) {
            return current.newlyEarnedBadges.isNotEmpty &&
                !listEquals(
                  previous.newlyEarnedBadges,
                  current.newlyEarnedBadges,
                );
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
                            onTap: () => const ProfileSettingsRoute()
                                .push<void>(context),
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
                                  (isTeacher
                                      ? l10n.teacherRoleFallback
                                      : l10n.profileStudentFallback),
                              meta: isTeacher
                                  ? ''
                                  : (state.overview.academic.group ?? ''),
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
                    child: _ProfileContent(state: state),
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
