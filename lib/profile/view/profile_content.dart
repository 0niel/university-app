part of 'profile_page.dart';

class _ProfileBody extends StatefulWidget {
  const _ProfileBody({required this.state});

  final ProfileState state;

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody> {
  final ScrollController _scrollController = ScrollController();
  String? _version;

  ProfileState get state => widget.state;

  @override
  void initState() {
    super.initState();
    TabReselectNotifier.instance.addListener(_onTabReselect);
    unawaited(_loadVersion());
  }

  @override
  void dispose() {
    TabReselectNotifier.instance.removeListener(_onTabReselect);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) setState(() => _version = info.version);
    } on Exception catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(exception: error, stack: stackTrace),
      );
    }
  }

  void _onTabReselect() {
    if (TabReselectNotifier.instance.tabIndex != 4 ||
        !_scrollController.hasClients ||
        _scrollController.positions.length != 1) {
      return;
    }
    final position = _scrollController.position;
    if (!position.hasContentDimensions) return;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    if (reduceMotion) {
      _scrollController.jumpTo(position.minScrollExtent);
      return;
    }
    unawaited(
      _scrollController.animateTo(
        position.minScrollExtent,
        duration: NinjaMotion.base,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  String _displayName(AppLocalizations l10n) {
    final academic = state.overview.academic;
    final user = state.user;
    return [
          academic.fullName,
          user.name,
          user.email?.split('@').firstOrNull,
        ].firstWhereOrNull((value) => value != null && value.isNotEmpty) ??
        l10n.profileStudentFallback;
  }

  String _meta(AppLocalizations l10n) {
    final academic = state.overview.academic;
    final parts = <String>[
      if (academic.group case final group? when group.isNotEmpty) group,
      if (academic.course case final course?) l10n.profileCourseLabel(course),
      if (academic.handle case final handle? when handle.isNotEmpty) '@$handle',
    ];
    return parts.isEmpty ? (state.user.email ?? '') : parts.join(' · ');
  }

  List<GamificationQuest> get _weekQuests {
    final supported = state.quests.where(isSupportedProfileQuest);
    final weekly = supported.where((quest) => quest.isWeekly).toList();
    return weekly.isEmpty
        ? supported.where((quest) => quest.isDaily).toList()
        : weekly;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final academic = state.overview.academic;
    final profile = state.gamificationProfile;
    final badges = [...state.earnedBadges, ...state.closestBadges];
    final friends = context.watch<FriendsListCubit>().state;
    final cardNumber = academic.studentCardNumber;
    final bottom = MediaQuery.paddingOf(context).bottom;
    return ListView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: EdgeInsets.only(bottom: kProfileBottomInset + bottom),
      children: [
        AppScreenHeader(
          title: l10n.profile,
          actions: [
            AppHeaderAction(
              icon: AppLineIcon.tune,
              semanticsLabel: l10n.settingsTitle,
              onTap: () => const ProfileSettingsRoute().push<void>(context),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xlg),
              if (state.user.isGuest) ...[
                AppBanner(
                  message: l10n.authGuestUpgradeSubtitle,
                  actionLabel: l10n.authGuestUpgradeTitle,
                  onAction: () => unawaited(showGuestUpgradeSheet(context)),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              ProfileIdentityRow(
                name: _displayName(l10n),
                meta: _meta(l10n),
                onTap: () => showEditProfileSheet(context),
              ),
              if (state.hasFailed(ProfileSection.profile))
                _sectionError(ProfileSection.profile),
              if (state.hasFailed(ProfileSection.overview))
                _sectionError(ProfileSection.overview),
              const SizedBox(height: AppSpacing.screen),
              AppTourAnchor(
                target: .profileStats,
                child: ProfileLevelCard(
                  xp: profile.xp,
                  streakDays: profile.streakDays,
                  groupRank: state.overview.groupRank,
                  onTap: () => showLeaderboardSheet(context),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ProfileActivityCard(
                streakDays: profile.streakDays,
                longestStreak: profile.longestStreak,
                history: state.overview.streakHistory,
              ),
              ProfileQuestsGroup(quests: _weekQuests),
              if (state.hasFailed(ProfileSection.quests))
                _sectionError(ProfileSection.quests),
            ],
          ),
        ),
        ProfileBadgesRail(
          badges: badges,
          totalBadges: state.overview.totalBadges,
          onAll: () => openNinjaPath(context),
          onBadge: () => openNinjaPath(context),
        ),
        if (state.hasFailed(ProfileSection.badges))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: _sectionError(ProfileSection.badges),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            28,
            AppSpacing.screen,
            0,
          ),
          child: AppListGroup(
            children: [
              ProfileLinkRow(
                icon: AppLineIcon.people,
                title: l10n.friendsTitle,
                meta: friends.status == FriendsListStatus.loaded
                    ? l10n.profileFriendsMeta(
                        friends.friends.length,
                        friends.onCampusCount(DateTime.now()),
                      )
                    : null,
                onTap: () => const FriendsRoute().push<void>(context),
              ),
              ProfileLinkRow(
                icon: AppLineIcon.contactless,
                title: l10n.profileStudentCard,
                meta: cardNumber == null || cardNumber.isEmpty
                    ? null
                    : l10n.profileCardNumber(cardNumber),
                onTap: () => const NfcPassRoute().push<void>(context),
              ),
              ProfileLinkRow(
                icon: AppLineIcon.tune,
                title: l10n.settingsTitle,
                onTap: () => const ProfileSettingsRoute().push<void>(context),
              ),
              ProfileLinkRow(
                icon: AppLineIcon.info,
                title: l10n.aboutApp,
                meta: _version,
                showChevron: false,
                onTap: () => const AboutAppRoute().push<void>(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionError(ProfileSection section) => AppErrorState(
    title: context.l10n.profileSectionLoadFailed,
    message: null,
    footnote: null,
    primaryLabel: context.l10n.retry,
    onPrimary: () => context.read<ProfileCubit>().reloadSection(section),
  );
}
