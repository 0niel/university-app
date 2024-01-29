import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap,
    this.onLongPress,
    this.url,
    this.description,
    this.launchMode = LaunchMode.externalApplication,
  }) : super(key: key);

  final String title;
  final String? url;
  final Widget icon;
  final LaunchMode launchMode;
  final String? description;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 156, maxHeight: 192),
      child: Card(
        color: AppTheme.colorsOf(context).background02,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onLongPress: onLongPress,
          onTap: () {
            if (onTap != null) {
              onTap!();
              return;
            }
            if (this.url == null) {
              return;
            }
            final Uri url = Uri.parse(this.url!);
            launchUrl(url, mode: launchMode);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                icon,
                const SizedBox(height: 12),
                Text(
                  title,
                  style: AppTextStyle.bodyBold.copyWith(
                    color: AppTheme.colorsOf(context).active,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      description!,
                      style: AppTextStyle.body.copyWith(
                        color: AppTheme.colorsOf(context).deactive,
                        height: 1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
