import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:url_launcher/url_launcher.dart';

class ContributorCard extends StatelessWidget {
  const ContributorCard({Key? key, required this.contributor}) : super(key: key);

  final Contributor contributor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.colorsOf(context).background02,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 37,
                backgroundColor: AppTheme.colorsOf(context).deactive,
                backgroundImage: NetworkImage(contributor.avatarUrl),
              ),
              const SizedBox(height: 16),
              Text(
                contributor.login,
                style: AppTextStyle.bodyBold,
              ),
              Text(
                '${contributor.contributions} ${Intl.plural(contributor.contributions, one: 'коммит', few: 'коммита', many: 'коммитов', other: 'коммитов')}',
                style: AppTextStyle.bodyRegular,
              ),
            ],
          ),
        ),
        onTap: () {
          launchUrl(Uri.parse(contributor.htmlUrl), mode: LaunchMode.externalApplication);
        },
      ),
    );
  }
}
