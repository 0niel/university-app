import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunityCard extends StatelessWidget {
  const CommunityCard({
    Key? key,
    required this.title,
    required this.url,
    required this.logo,
    this.description,
    this.launchMode = LaunchMode.externalApplication,
  }) : super(key: key);

  final String title;
  final String url;
  final Widget logo;
  final LaunchMode launchMode;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.colorsOf(context).background02,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
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
              SizedBox(width: 40, height: 40, child: logo),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.titleM.copyWith(
                        color: AppTheme.colorsOf(context).active,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (description != null) ...[
                      Text(
                        description!,
                        style: AppTextStyle.captionL.copyWith(
                          color: AppTheme.colorsOf(context).deactive,
                          height: 1.1,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
