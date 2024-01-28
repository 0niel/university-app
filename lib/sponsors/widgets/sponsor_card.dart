import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsorCard extends StatelessWidget {
  const SponsorCard({Key? key, required this.sponsor}) : super(key: key);

  final Sponsor sponsor;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: const GradientRotation(2.35619),
              colors: [
                AppTheme.colorsOf(context).colorful02,
                AppTheme.colorsOf(context).colorful03,
              ],
            ),
          ),
          padding: const EdgeInsets.all(1),
          child: Material(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.background,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: sponsor.url != null
                  ? () {
                      launchUrl(Uri.parse(sponsor.url!), mode: LaunchMode.externalApplication);
                    }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppTheme.colorsOf(context).deactive,
                          backgroundImage: sponsor.avatarUrl != null ? NetworkImage(sponsor.avatarUrl!) : null,
                          child: sponsor.avatarUrl == null ? Text(sponsor.username[0]) : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sponsor.username,
                                style: AppTextStyle.titleM,
                              ),
                              if (sponsor.about != null)
                                Text(
                                  sponsor.about.toString(),
                                  style: AppTextStyle.captionL.copyWith(
                                    color: AppTheme.colorsOf(context).deactive,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (sponsor.url != null)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            color: AppTheme.colorsOf(context).colorful01,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            UniconsLine.link,
                            color: AppTheme.colorsOf(context).active,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
