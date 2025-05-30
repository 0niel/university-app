import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.onLongPress,
    this.url,
    this.description,
    this.launchMode = LaunchMode.externalApplication,
  });

  final String title;
  final String? url;
  final Widget icon;
  final LaunchMode launchMode;
  final String? description;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 160, maxHeight: 192),
        child: Card(
          color: Theme.of(context).extension<AppColors>()!.background02,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: PlatformInkWell(
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
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  icon,
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: AppTextStyle.bodyBold.copyWith(
                      color: Theme.of(context).extension<AppColors>()!.active,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        description!,
                        style: AppTextStyle.body.copyWith(
                          color: Theme.of(context).extension<AppColors>()!.deactive,
                          height: 1.2,
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
      ),
    );
  }
}
