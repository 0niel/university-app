import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_map_cubit.dart';
import 'package:rtu_mirea_app/friends/services/friends_location_service.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'ninja_geo_settings_section.dart';
part 'ninja_geo_sharing_toggle_row.dart';

class NinjaGeoSharingSheet extends StatelessWidget {
  const NinjaGeoSharingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendsMapCubit, FriendsMapState>(
      builder: (context, state) {
        final cubit = context.read<FriendsMapCubit>();
        final settings = state.geoSettings;
        final l10n = context.l10n;
        final hidden = settings.visibility == GeoVisibility.none;
        return Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            if (state.locationPublishFailed) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: NinjaBanner(
                  tone: NinjaBannerTone.warn,
                  title: l10n.friendsLocationPublishFailed,
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
            ],
            if (state.privacySyncFailed) ...[
              Padding(
                padding: const .symmetric(horizontal: AppSpacing.xl),
                child: AppErrorState(
                  title: l10n.error,
                  message: l10n.friendsPrivacySyncError,
                  footnote: null,
                  primaryLabel: l10n.retry,
                  onPrimary: state.privacyBusy ? null : cubit.retryPrivacy,
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
            ],
            _NinjaGeoSharingToggleRow(
              icon: AppLineIcon.pin,
              title: l10n.friendsShareGeo,
              subtitle: l10n.friendsShareGeoSub,
              value: settings.sharing,
              onChanged: state.privacyBusy
                  ? null
                  : (v) =>
                        cubit.updateGeoSettings(settings.copyWith(sharing: v)),
            ),
            const _NinjaGeoSettingsDivider(),
            _NinjaGeoSharingToggleRow(
              icon: AppLineIcon.hide,
              title: l10n.friendsGhostMode,
              subtitle: l10n.friendsGhostSub,
              value: state.isGhost,
              onChanged: !state.privacyBusy && settings.sharing && !hidden
                  ? (_) => cubit.toggleGhostMode()
                  : null,
            ),
            const SizedBox(height: AppSpacing.contentGap),
            _NinjaGeoSettingsSection(
              title: l10n.friendsWhoSeesExact,
              helper: switch (settings.visibility) {
                GeoVisibility.none => l10n.friendsVisNoneSub,
                GeoVisibility.all => l10n.friendsVisFriendsSub,
                GeoVisibility.students => l10n.friendsVisStudentsSub,
              },
              child: AppSegmentedControl<GeoVisibility>(
                onCanvas: true,
                value: settings.visibility,
                onChanged: state.privacyBusy
                    ? null
                    : (v) => cubit.updateGeoSettings(
                        settings.copyWith(visibility: v),
                      ),
                options: [
                  AppSegmentedOption(
                    value: GeoVisibility.all,
                    label: l10n.friendsVisAll,
                  ),
                  AppSegmentedOption(
                    value: GeoVisibility.students,
                    label: l10n.friendsVisStudents,
                  ),
                  AppSegmentedOption(
                    value: GeoVisibility.none,
                    label: l10n.friendsVisNone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.contentGap),
            _NinjaGeoSettingsSection(
              title: l10n.friendsPrecisionHeader,
              child: AppSegmentedControl<GeoPrecision>(
                onCanvas: true,
                value: settings.precision,
                onChanged: state.privacyBusy
                    ? null
                    : (v) => cubit.updateGeoSettings(
                        settings.copyWith(precision: v),
                      ),
                options: [
                  AppSegmentedOption(
                    value: GeoPrecision.exact,
                    label: l10n.friendsPrecisionExact,
                  ),
                  AppSegmentedOption(
                    value: GeoPrecision.campus,
                    label: l10n.friendsPrecisionCampus,
                  ),
                  AppSegmentedOption(
                    value: GeoPrecision.city,
                    label: l10n.friendsPrecisionCity,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.contentGap),
            _NinjaGeoSettingsSection(
              title: l10n.friendsBackgroundTitle,
              helper:
                  !kIsWeb &&
                      (defaultTargetPlatform == TargetPlatform.android ||
                          defaultTargetPlatform == TargetPlatform.iOS)
                  ? l10n.friendsBackgroundMobileSub
                  : l10n.friendsBackgroundForegroundSub,
              child: Text(
                state.backgroundLocationActive
                    ? l10n.friendsBackgroundActive
                    : switch (state.locationStatus) {
                        FriendsLocationStatus.locating =>
                          l10n.friendsLocationLocating,
                        FriendsLocationStatus.active =>
                          l10n.friendsLocationForegroundActive,
                        FriendsLocationStatus.serviceDisabled =>
                          l10n.friendsLocationServiceDisabled,
                        FriendsLocationStatus.unavailable =>
                          l10n.friendsLocationUnsupported,
                        FriendsLocationStatus.permissionDenied ||
                        FriendsLocationStatus.permissionDeniedForever ||
                        FriendsLocationStatus.failure =>
                          l10n.friendsLocationUnavailable,
                        FriendsLocationStatus.stopped =>
                          l10n.friendsBackgroundInactive,
                      },
                style: AppText.body.copyWith(color: context.colors.ink),
              ),
            ),
            if (state.locationPermissionDenied ||
                state.locationStatus == FriendsLocationStatus.serviceDisabled ||
                state.locationStatus == FriendsLocationStatus.failure ||
                state.locationStatus == FriendsLocationStatus.unavailable)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: AppButton.text(
                  label: state.locationPermissionDenied
                      ? l10n.friendsLocationRetry
                      : l10n.retry,
                  onPressed: cubit.retryLocation,
                ),
              ),
            const SizedBox(height: AppSpacing.md),
          ],
        );
      },
    );
  }
}
