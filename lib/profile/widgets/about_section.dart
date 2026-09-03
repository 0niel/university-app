import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_row.dart';

const kGithubRepoLabel = 'github.com/0niel/university-app';

class AboutSection extends StatelessWidget {
  const AboutSection({
    required this.appName,
    required this.onTap,
    this.version,
    super.key,
  });

  final String appName;
  final VoidCallback onTap;
  final String? version;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        SettingsRow(
          title: appName,
          lineIcon: AppLineIcon.info,
          value: l10n.settingsAboutVersion(version ?? '—'),
          onTap: onTap,
        ),
        Padding(
          padding: const .fromLTRB(8, 4, 8, 10),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: l10n.settingsAboutDescription),
                TextSpan(
                  text: kGithubRepoLabel,
                  style: TextStyle(color: colors.accent),
                ),
              ],
            ),
            style: AppText.caption.copyWith(height: 1.5, color: colors.muted),
          ),
        ),
      ],
    );
  }
}
