import 'package:app_ui/app_ui.dart';
import 'package:community_catalog_repository/community_catalog_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/communities/widgets/community_logo_fallback.dart';
import 'package:rtu_mirea_app/communities/widgets/community_platform.dart';
import 'package:rtu_mirea_app/communities/widgets/community_platform_badge.dart';

class CommunityLogo extends StatelessWidget {
  const CommunityLogo({required this.entry, super.key});

  final CommunityCatalogEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final scale = Theme.of(context).scale;
    final logoUrl = safeCommunityUri(entry.logoUrl);
    final entryUri = entry.safeUri;
    final platform = entryUri == null
        ? CommunityPlatform.web
        : communityPlatformFor(entryUri);
    final size = scale.icon(44);
    return Stack(
      clipBehavior: .none,
      children: [
        ClipRRect(
          borderRadius: .circular(scale.radius(NinjaRadius.control)),
          child: logoUrl == null
              ? CommunityLogoFallback(size: size)
              : Image.network(
                  logoUrl.toString(),
                  width: size,
                  height: size,
                  fit: .cover,
                  semanticLabel: entry.title,
                  errorBuilder: (_, _, _) => CommunityLogoFallback(size: size),
                ),
        ),
        Positioned(
          right: -scale.space(3),
          bottom: -scale.space(3),
          child: CommunityPlatformBadge(
            platform: platform,
            ringColor: colors.surface,
          ),
        ),
      ],
    );
  }
}
