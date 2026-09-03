import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/widgets/app_map_tiles.dart';
import 'package:url_launcher/url_launcher.dart';

class FriendsMapAttribution extends StatelessWidget {
  const FriendsMapAttribution({required this.panelExtent, super.key});

  static final Uri _copyrightUri = Uri.parse(
    'https://www.openstreetmap.org/copyright',
  );

  final ValueListenable<double> panelExtent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ValueListenableBuilder<double>(
      valueListenable: panelExtent,
      builder: (context, extent, child) {
        final height = MediaQuery.heightOf(context);
        final bottom = (height * extent + 10).clamp(110.0, double.infinity);
        return Positioned(
          left: AppSpacing.screen,
          bottom: bottom,
          child: child!,
        );
      },
      child: AppPressable(
        onTap: () => unawaited(
          launchUrl(_copyrightUri, mode: .externalApplication),
        ),
        semanticsLabel: AppMapTiles.attribution,
        pressedScale: 0.98,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppControlSize.iconButton,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.92),
              borderRadius: .circular(AppRadius.full),
            ),
            child: Padding(
              padding: const .symmetric(horizontal: AppSpacing.md, vertical: 7),
              child: Center(
                child: Text(
                  AppMapTiles.attribution,
                  style: AppText.caption.copyWith(color: colors.muted),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
