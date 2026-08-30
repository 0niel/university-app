import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_map_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'ninja_geo_section_card.dart';
part 'ninja_geo_sharing_toggle_card.dart';

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
            if (state.privacySyncFailed) ...[
              NinjaBanner(
                tone: .danger,
                title: l10n.error,
                body: l10n.friendsPrivacySyncError,
                actionLabel: l10n.retry,
                onAction: () => cubit.updateGeoSettings(settings),
              ),
              const SizedBox(height: 14),
            ],
            _NinjaGeoSharingToggleCard(
              icon: AppLineIcon.pin,
              title: l10n.friendsShareGeo,
              subtitle: l10n.friendsShareGeoSub,
              value: settings.sharing,
              onChanged: state.privacyBusy
                  ? null
                  : (v) =>
                        cubit.updateGeoSettings(settings.copyWith(sharing: v)),
            ),
            _NinjaGeoSharingToggleCard(
              icon: AppLineIcon.hide,
              title: l10n.friendsGhostMode,
              subtitle: l10n.friendsGhostSub,
              value: state.isGhost,
              onChanged: !state.privacyBusy && settings.sharing && !hidden
                  ? (_) => cubit.toggleGhostMode()
                  : null,
            ),
            const SizedBox(height: 18),
            _NinjaGeoSectionCard(
              title: l10n.friendsWhoSeesExact,
              helper: hidden ? l10n.friendsVisNoneSub : null,
              child: NinjaSegmented<GeoVisibility>(
                value: settings.visibility,
                expanded: true,
                onChanged: state.privacyBusy
                    ? null
                    : (v) => cubit.updateGeoSettings(
                        settings.copyWith(visibility: v),
                      ),
                segments: [
                  NinjaSegment(
                    value: GeoVisibility.all,
                    label: l10n.friendsVisAll,
                  ),
                  NinjaSegment(
                    value: GeoVisibility.none,
                    label: l10n.friendsVisNone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _NinjaGeoSectionCard(
              title: l10n.friendsPrecisionHeader,
              child: NinjaSegmented<GeoPrecision>(
                value: settings.precision,
                expanded: true,
                onChanged: state.privacyBusy
                    ? null
                    : (v) => cubit.updateGeoSettings(
                        settings.copyWith(precision: v),
                      ),
                segments: [
                  NinjaSegment(
                    value: GeoPrecision.exact,
                    label: l10n.friendsPrecisionExact,
                  ),
                  NinjaSegment(
                    value: GeoPrecision.campus,
                    label: l10n.friendsPrecisionCampus,
                  ),
                  NinjaSegment(
                    value: GeoPrecision.city,
                    label: l10n.friendsPrecisionCity,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
