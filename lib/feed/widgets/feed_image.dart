import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class FeedImage extends StatelessWidget {
  const FeedImage({
    required this.radius,
    super.key,
    this.imageUrl,
    this.width,
    this.height,
  });

  final String? imageUrl;
  final double radius;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final borderRadius = BorderRadius.circular(radius);
    final placeholder = AppStripePlaceholder(borderRadius: borderRadius);
    return SizedBox(
      width: width,
      height: height,
      child: url == null || url.isEmpty
          ? placeholder
          : ClipRRect(
              borderRadius: borderRadius,
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (_, _) => placeholder,
                errorWidget: (_, _, _) => placeholder,
              ),
            ),
    );
  }
}
