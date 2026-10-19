import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/design_preview/fixtures/preview_fixtures.dart';
import 'package:rtu_mirea_app/design_preview/widgets/preview_page.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/profile/profile_widgets.dart';

class PreviewProfilePage extends StatelessWidget {
  const PreviewProfilePage({required this.onTab, super.key});

  final ValueChanged<int> onTab;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PreviewPage(
      children: [
        NinjaDisplayHeader(title: l10n.navProfile, padding: EdgeInsets.zero),
        ProfileIdentityRow(
          name: PreviewFixtures.name,
          meta:
              '${PreviewFixtures.group} · '
              '${l10n.profileCourseLabel(PreviewFixtures.course)}',
        ),
        ProfileLevelCard(
          xp: PreviewFixtures.profile.xp,
          streakDays: PreviewFixtures.profile.streakDays,
          groupRank: PreviewFixtures.groupRank,
        ),
        ProfileMetricCards(
          metrics: [
            ProfileMetric(
              value: PreviewFixtures.gpa,
              label: l10n.profileMetricGpa,
            ),
            ProfileMetric(
              value: PreviewFixtures.attendance,
              label: l10n.profileMetricAttendance,
            ),
            ProfileMetric(
              value: PreviewFixtures.daysToExam,
              label: l10n.profileMetricExam,
              onTap: () => onTab(1),
            ),
          ],
        ),
        const ProfileBadgesRail(badges: [], totalBadges: 0),
        AppListGroup(
          children: [
            AppListRow(
              title: l10n.schedule,
              leading: const AppIconTile(icon: AppLineIcon.calendar),
              onTap: () => onTab(1),
            ),
            AppListRow(
              title: l10n.navServices,
              leading: const AppIconTile(icon: AppLineIcon.services),
              onTap: () => onTab(3),
            ),
          ],
        ),
      ],
    );
  }
}
