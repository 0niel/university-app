import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/communities/widgets/community_style.dart';

class CommunityTile extends StatelessWidget {
  const CommunityTile({
    required this.name,
    super.key,
    this.logoUrl,
    this.size = 48,
    this.radius = AppRadius.banner,
    this.background,
    this.foreground,
  });

  final String name;
  final String? logoUrl;
  final double size;
  final double radius;
  final Color? background;
  final Color? foreground;

  double get _fontSize {
    if (size >= 64) return 20;
    if (size >= 48) return 13;
    return 12;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = foreground ?? communityTone(colors, name);
    final logoUrl = this.logoUrl;
    final label = Text(
      communityAbbreviation(name),
      style: AppText.sans(
        _fontSize,
        FontWeight.w800,
        height: 1,
      ).copyWith(color: tone),
    );
    return AppIconTile(
      size: size,
      radius: radius,
      background: background ?? colors.tintOf(tone),
      child: logoUrl == null || logoUrl.isEmpty
          ? label
          : ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: CachedNetworkImage(
                imageUrl: logoUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                placeholder: (_, _) => Center(child: label),
                errorWidget: (_, _, _) => Center(child: label),
              ),
            ),
    );
  }
}
