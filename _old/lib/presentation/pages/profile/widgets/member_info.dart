import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberInfo extends StatelessWidget {
  const MemberInfo(
      {Key? key,
      required this.username,
      required this.avatarUrl,
      required this.profileUrl})
      : super(key: key);
  final String username;
  final String avatarUrl;
  final String profileUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(children: [
        CachedNetworkImage(
          progressIndicatorBuilder: (context, url, progress) =>
              const SizedBox(width: 60, height: 60),
          imageUrl: avatarUrl,
          errorWidget: (context, url, error) => const Icon(Icons.error),
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: 30,
            backgroundImage: imageProvider,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          username,
          style: DarkTextTheme.bodyBold,
        ),
      ]),
      onTap: () {
        launch(profileUrl);
      },
    );
  }
}
