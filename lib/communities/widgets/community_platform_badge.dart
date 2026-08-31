import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/communities/widgets/community_platform.dart';

class CommunityPlatformBadge extends StatelessWidget {
  const CommunityPlatformBadge({
    required this.platform,
    required this.ringColor,
    super.key,
  });

  final CommunityPlatform platform;
  final Color ringColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final label = switch (platform) {
      .telegram => 'TG',
      .vk => 'VK',
      .discord => 'DS',
      .web => 'W',
    };
    return DecoratedBox(
      decoration: BoxDecoration(color: ringColor, shape: .circle),
      child: Padding(
        padding: const .all(2),
        child: Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: colors.ink, shape: .circle),
          child: Text(
            label,
            style: NinjaText.microLabel.copyWith(
              fontSize: 7,
              color: colors.onInk,
            ),
          ),
        ),
      ),
    );
  }
}
