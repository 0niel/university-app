import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/friends/widgets/friends_circle_button.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class FriendsMapControls extends StatelessWidget {
  const FriendsMapControls({
    required this.panelExtent,
    required this.isGhost,
    required this.onToggleGhost,
    required this.onGeoSettings,
    super.key,
    this.onMyLocation,
  });

  final ValueListenable<double> panelExtent;
  final bool isGhost;
  final VoidCallback onToggleGhost;
  final VoidCallback onGeoSettings;
  final VoidCallback? onMyLocation;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ValueListenableBuilder<double>(
      valueListenable: panelExtent,
      builder: (context, extent, child) {
        final height = MediaQuery.heightOf(context);
        final bottom = (height * extent + 14).clamp(120.0, height - 250);
        final visible = extent < 0.46;
        final reduceMotion =
            MediaQuery.disableAnimationsOf(context) ||
            MediaQuery.accessibleNavigationOf(context);
        return Positioned(
          right: NinjaMetrics.screenPadding,
          bottom: bottom,
          child: IgnorePointer(
            ignoring: !visible,
            child: AnimatedOpacity(
              opacity: visible ? 1 : 0,
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 160),
              child: child,
            ),
          ),
        );
      },
      child: Column(
        spacing: 10,
        children: [
          FriendsCircleButton(
            icon: .pin,
            label: l10n.friendsMyLocation,
            onTap: onMyLocation,
          ),
          FriendsCircleButton(
            icon: .hide,
            label: isGhost ? l10n.friendsGhostModeOff : l10n.friendsGhostMode,
            selected: isGhost,
            onTap: onToggleGhost,
          ),
          FriendsCircleButton(
            icon: .settings,
            label: l10n.friendsGeoSharing,
            onTap: onGeoSettings,
          ),
        ],
      ),
    );
  }
}
