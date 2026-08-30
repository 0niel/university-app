import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rtu_mirea_app/common/utils/app_cache.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_hce_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/pass_security_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/utils/settings_search_filter.dart';
import 'package:rtu_mirea_app/profile/view/notifications_settings_page.dart';
import 'package:rtu_mirea_app/profile/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

const kGithubUrl = 'https://github.com/0niel/university-app';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final AppCache _cache = const AppCache();
  final TextEditingController _searchController = TextEditingController();
  String? _cacheLabel;
  String? _version;
  var _clearingCache = false;
  var _query = '';

  @override
  void initState() {
    super.initState();
    unawaited(context.read<PassSecurityCubit>().refreshCapability());
    unawaited(context.read<NfcHceCubit>().refresh());
    unawaited(_loadCacheSize());
    unawaited(_loadVersion());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  Future<void> _loadCacheSize() async {
    try {
      final bytes = await _cache.estimateBytes();
      if (!mounted) return;
      setState(() => _cacheLabel = filesize(bytes));
    } on Exception catch (error, stackTrace) {
      log(
        'Failed to estimate cache size',
        error: error,
        stackTrace: stackTrace,
        name: 'ProfileSettingsPage',
      );
    }
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() => _version = info.version);
    } on Exception catch (error, stackTrace) {
      log(
        'Failed to read package version',
        error: error,
        stackTrace: stackTrace,
        name: 'ProfileSettingsPage',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.ninja.canvas,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: _buildBody,
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final settings = state.settings;
    final academic = state.overview.academic;
    final filter = SettingsSearchFilter(query: _query, l10n: l10n);

    final name =
        academic.fullName ??
        state.user.name ??
        (state.user.email?.split('@').firstOrNull ??
            l10n.profileStudentFallback);
    final identityMeta = [
      ?academic.group,
      if (academic.handle != null) '@${academic.handle}',
    ].join(' · ');
    final cold =
        state.status == ProfileStatus.loading &&
        state.gamificationProfile.isEmpty;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: colors.canvas,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leadingWidth: 60,
          leading: Center(
            child: NinjaIconButton(
              icon: const AppLineIconWidget(.chevronL, size: 20),
              tooltip: l10n.back,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: Text(
            l10n.settingsTitle,
            style: NinjaText.appBarTitle.copyWith(color: colors.ink),
          ),
        ),
        if (cold)
          const SliverToBoxAdapter(child: SettingsSkeleton.settings())
        else ...[
          SliverToBoxAdapter(
            child: ProfileShortcut(
              name: name,
              subtitle: identityMeta.isEmpty
                  ? (state.user.email ?? '')
                  : identityMeta,
              onTap: () => showEditIdentitySheet(context, academic),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SettingsSearchDelegate(
              hint: l10n.search,
              controller: _searchController,
              textScale: MediaQuery.textScalerOf(context).scale(1),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          SliverList.list(
            children: [
              if (state.hasFailed(.settings))
                SettingsFailureCard(
                  onRetry: () => unawaited(
                    context.read<ProfileCubit>().reloadSection(.settings),
                  ),
                ),

              if (filter.isActive && !filter.hasResults)
                SettingsSearchEmpty(onClear: _clearSearch),

              if (filter.showAppearance)
                SettingsSection(
                  label: l10n.settingsAppearance,
                  children: const [SettingsAppearance()],
                ),

              if (filter.showNotifications)
                SettingsNotificationsSection(
                  enabled: settings.notificationsEnabled,
                  onTap: () => _openNotifications(context),
                ),

              if (filter.showPrivacy)
                SettingsPrivacySection(
                  settings: settings,
                  onChanged: (next) => _updateSettings(context, next),
                ),

              if (filter.showSchedule)
                SettingsScheduleSection(group: academic.group),

              if (filter.showHome) const SettingsHomeSection(),

              if (filter.showSupport) ...[
                const SizedBox(height: 20),
                SupportBanner(
                  onTap: () {
                    unawaited(_openGithub());
                  },
                ),
              ],

              if (filter.showData)
                SettingsDataSection(
                  cacheLabel: _cacheLabel,
                  onClearCache: _clearingCache
                      ? null
                      : () {
                          unawaited(_clearCache());
                        },
                ),

              if (filter.showAbout) SettingsAboutSection(version: _version),

              if (filter.showAccount) const SettingsAccountSection(),

              const SettingsFooterNote(),
            ],
          ),
        ],
      ],
    ).animatePageEntrance();
  }

  void _updateSettings(BuildContext context, UserSettings next) {
    unawaited(context.read<ProfileCubit>().updateSettings(next));
  }

  void _openNotifications(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider.value(
            value: profileCubit,
            child: const NotificationsSettingsPage(),
          ),
        ),
      ),
    );
  }

  Future<void> _clearCache() async {
    setState(() => _clearingCache = true);
    final l10n = context.l10n;
    try {
      await _cache.clear();
      await _loadCacheSize();
      if (!mounted) return;
      showNinjaToast(context, message: l10n.settingsCacheCleared);
    } on Exception catch (error, stackTrace) {
      log(
        'Failed to clear cache',
        error: error,
        stackTrace: stackTrace,
        name: 'ProfileSettingsPage',
      );
      if (mounted) {
        showNinjaToast(context, message: l10n.error, showCheck: false);
      }
    } finally {
      if (mounted) setState(() => _clearingCache = false);
    }
  }

  Future<void> _openGithub() async {
    final uri = Uri.parse(kGithubUrl);
    try {
      final opened = await launchUrl(uri, mode: .externalApplication);
      if (!opened && mounted) {
        showNinjaToast(context, message: context.l10n.error, showCheck: false);
      }
    } on Exception catch (error, stackTrace) {
      log(
        'Failed to open GitHub',
        error: error,
        stackTrace: stackTrace,
        name: 'ProfileSettingsPage',
      );
    }
  }
}

class SettingsSearchDelegate extends SliverPersistentHeaderDelegate {
  const SettingsSearchDelegate({
    required this.hint,
    required this.textScale,
    required this.onChanged,
    this.controller,
  });

  final String hint;
  final double textScale;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  double get _height => 72 + (textScale - 1).clamp(0, 1) * 22;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: ColoredBox(
        color: context.ninja.canvas,
        child: Padding(
          padding: const .fromLTRB(
            NinjaMetrics.screenPadding,
            10,
            NinjaMetrics.screenPadding,
            8,
          ),
          child: NinjaInput(
            controller: controller,
            placeholder: hint,
            leadingIcon: const AppLineIconWidget(.search, size: 19),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SettingsSearchDelegate oldDelegate) =>
      oldDelegate.hint != hint ||
      oldDelegate.textScale != textScale ||
      oldDelegate.controller != controller;
}
