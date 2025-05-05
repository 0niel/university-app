import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunityCard extends StatelessWidget {
  const CommunityCard({
    super.key,
    required this.title,
    required this.url,
    required this.logo,
    this.description,
    this.launchMode = LaunchMode.externalApplication,
  });

  final String title;
  final String url;
  final Widget logo;
  final LaunchMode launchMode;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        color: Theme.of(context).extension<AppColors>()!.background02,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: PlatformInkWell(
          onTap: () {
            final Uri url = Uri.parse(this.url);
            launchUrl(url, mode: launchMode);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 48, height: 48, child: ClipRRect(borderRadius: BorderRadius.circular(12), child: logo)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyle.titleM.copyWith(
                          color: Theme.of(context).extension<AppColors>()!.active,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          description!,
                          style: AppTextStyle.captionL.copyWith(
                            color: Theme.of(context).extension<AppColors>()!.deactive,
                            height: 1.2,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
