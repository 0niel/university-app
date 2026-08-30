part of 'profile_page.dart';

class _ProfileBody extends StatefulWidget {
  const _ProfileBody({required this.state});

  final ProfileState state;

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody> {
  final ScrollController _scrollController = ScrollController();

  ProfileState get state => widget.state;

  @override
  void initState() {
    super.initState();
    TabReselectNotifier.instance.addListener(_onTabReselect);
  }

  @override
  void dispose() {
    TabReselectNotifier.instance.removeListener(_onTabReselect);
    _scrollController.dispose();
    super.dispose();
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
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  void _openSettings() {
    final profileCubit = context.read<ProfileCubit>();
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider.value(
            value: profileCubit,
            child: const ProfileSettingsPage(),
          ),
        ),
      ),
    );
  }

  Future<void> _shareProfile() async {
    final link = DeepLinks.shareLink('/profile');
    await Clipboard.setData(ClipboardData(text: link.toString()));
    if (mounted) {
      showNinjaToast(context, message: context.l10n.profileLinkCopied);
    }
  }

  void _retry(ProfileSection section) {
    unawaited(context.read<ProfileCubit>().reloadSection(section));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final bottom = MediaQuery.paddingOf(context).bottom;
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverAppBar(
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: colors.canvas,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: NinjaMetrics.screenPadding,
          title: Text(
            l10n.navProfile,
            style: NinjaText.appBarTitle.copyWith(color: colors.ink),
          ),
          actions: [
            NinjaIconButton(
              icon: const AppLineIconWidget(.share, size: 20),
              tooltip: l10n.share,
              onPressed: () => unawaited(_shareProfile()),
            ),
            const SizedBox(width: 8),
            NinjaIconButton(
              icon: const AppLineIconWidget(.settings, size: 20),
              tooltip: l10n.settingsTitle,
              onPressed: _openSettings,
            ),
            const SizedBox(width: NinjaMetrics.screenPadding),
          ],
        ),
        SliverToBoxAdapter(
          child: _ProfileWidth(
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                ..._sections(context),
                SizedBox(height: bottom + 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _sections(BuildContext context) => [
    ..._identitySection(context),
    AppTourAnchor(
      target: .profileStats,
      child: _ProfileStatsRow(
        xp: state.gamificationProfile.xp,
        shurikens: state.gamificationProfile.shurikens,
        earnedBadges: state.overview.earnedBadges,
        totalBadges: state.overview.totalBadges,
        onAllBadges: () => _openNinjaPath(context),
      ),
    ),
    _ProfileStreakSection(
      streakDays: state.gamificationProfile.streakDays,
      longestStreak: state.gamificationProfile.longestStreak,
      history: state.hasStreakHistory ? state.overview.streakHistory : const [],
    ),
    _ProfilePathEntry(
      questsDone: state.dailyDone,
      questsTotal: state.dailyQuests.length,
      groupRank: state.overview.groupRank,
      onTap: () => _openNinjaPath(context),
    ),
    ..._achievementsSection(context),
    _ProfileAccountEntry(onTap: _openSettings),
  ];

  List<Widget> _identitySection(BuildContext context) {
    final l10n = context.l10n;
    final academic = state.overview.academic;
    final user = state.user;
    final displayName =
        [
          academic.fullName,
          user.name,
          user.email?.split('@').firstOrNull,
        ].firstWhereOrNull((value) => value != null && value.isNotEmpty) ??
        l10n.profileStudentFallback;
    final metaParts = <String>[
      if (academic.group case final group? when group.isNotEmpty) group,
      if (academic.course case final course?) l10n.profileCourseLabel(course),
      if (academic.handle case final handle? when handle.isNotEmpty) '@$handle',
    ];
    final identityFailed =
        state.hasFailed(.profile) || state.hasFailed(.overview);
    return [
      _ProfileIdentity(
        name: displayName,
        meta: metaParts.isEmpty ? (user.email ?? '') : metaParts.join(' · '),
      ),
      if (identityFailed)
        _ProfileSectionError(
          onRetry: () => _retry(
            state.hasFailed(.profile)
                ? ProfileSection.profile
                : ProfileSection.overview,
          ),
        ),
    ];
  }

  List<Widget> _achievementsSection(BuildContext context) {
    final l10n = context.l10n;
    if (state.hasFailed(.badges)) {
      return [
        _ProfileSectionLabel(label: l10n.profileBadgesSection),
        _ProfileSectionError(onRetry: () => _retry(.badges)),
      ];
    }
    final badges = [...state.earnedBadges, ...state.closestBadges];
    if (badges.isEmpty) {
      if (state.status == ProfileStatus.loading) return const [];
      return [
        _ProfileSectionLabel(label: l10n.profileBadgesSection),
        _ProfileAchievementsEmpty(onTap: () => _openNinjaPath(context)),
      ];
    }
    return [
      _ProfileSectionLabel(
        label: l10n.profileBadgesSection,
        action: l10n.all,
        onAction: () => _openNinjaPath(context),
      ),
      _ProfileAchievementTiles(
        badges: badges,
        onTap: () => _openNinjaPath(context),
      ),
    ];
  }
}
