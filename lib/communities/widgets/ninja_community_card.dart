import 'package:app_ui/app_ui.dart';
import 'package:community_catalog_repository/community_catalog_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/communities/widgets/community_logo.dart';
import 'package:rtu_mirea_app/communities/widgets/community_platform.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

typedef CommunityUrlLauncher = Future<bool> Function(Uri uri);

class NinjaCommunityCard extends StatelessWidget {
  const NinjaCommunityCard({
    required this.entry,
    this.showDescription = false,
    this.onLaunch,
    super.key,
  });

  final CommunityCatalogEntry entry;
  final bool showDescription;
  final CommunityUrlLauncher? onLaunch;

  Future<void> _open(BuildContext context) async {
    final uri = entry.safeUri;
    if (uri == null) {
      _showLaunchError(context);
      return;
    }
    await launchCommunityUrl(context, uri, onLaunch: onLaunch);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final scale = Theme.of(context).scale;
    final membersCount = entry.membersCount;
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        10,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Semantics(
          button: true,
          label: entry.title,
          child: AppPressable(
            onTap: () => _open(context),
            child: Padding(
              padding: EdgeInsets.all(scale.space(16)),
              child: Row(
                children: [
                  CommunityLogo(entry: entry),
                  SizedBox(width: scale.space(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          entry.title,
                          maxLines: 2,
                          overflow: .ellipsis,
                          style: NinjaText.body.copyWith(color: colors.ink),
                        ),
                        if (showDescription &&
                            entry.description.isNotEmpty) ...[
                          SizedBox(height: scale.space(2)),
                          Text(
                            entry.description,
                            maxLines: 2,
                            overflow: .ellipsis,
                            style: NinjaText.subtext.copyWith(
                              color: colors.muted,
                            ),
                          ),
                        ] else if (membersCount != null) ...[
                          SizedBox(height: scale.space(2)),
                          Text(
                            context.l10n.communitiesMembersCount(
                              _formatCount(membersCount),
                            ),
                            style: NinjaText.subtext.copyWith(
                              color: colors.muted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: scale.space(8)),
                  AppLineIconWidget(
                    AppLineIcon.external,
                    size: scale.icon(18),
                    color: colors.chevron,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> _launchExternally(Uri uri) =>
    launchUrl(uri, mode: .externalApplication);

Future<void> launchCommunityUrl(
  BuildContext context,
  Uri uri, {
  CommunityUrlLauncher? onLaunch,
}) async {
  if (safeCommunityUri(uri.toString()) == null) {
    _showLaunchError(context);
    return;
  }
  try {
    final didLaunch = await (onLaunch ?? _launchExternally)(uri);
    if (!didLaunch && context.mounted) _showLaunchError(context);
  } on Object {
    if (context.mounted) _showLaunchError(context);
  }
}

void _showLaunchError(BuildContext context) {
  showNinjaToast(context, showCheck: false, message: context.l10n.error);
}

String _formatCount(int count) {
  if (count < 1000) return '$count';
  final thousands = count / 1000;
  return '${thousands.toStringAsFixed(count % 1000 == 0 ? 0 : 1)}K';
}
