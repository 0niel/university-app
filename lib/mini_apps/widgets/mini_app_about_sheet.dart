import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_consent_sheet.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_labels.dart';
import 'package:rtu_mirea_app/navigation/deep_links.dart';
import 'package:share_plus/share_plus.dart';

class MiniAppAboutSheet extends StatefulWidget {
  const MiniAppAboutSheet({
    required this.app,
    required this.onRate,
    super.key,
    this.onPermissionsChanged,
  });

  final MiniApp app;

  final Future<void> Function(int rating) onRate;

  final Future<void> Function(List<MiniAppPermission> scopes)?
  onPermissionsChanged;

  @override
  State<MiniAppAboutSheet> createState() => _MiniAppAboutSheetState();
}

class _MiniAppAboutSheetState extends State<MiniAppAboutSheet> {
  late int _myRating = widget.app.myRating ?? 0;
  late final Set<MiniAppPermission> _granted = {
    ...?widget.app.grantedPermissions,
  };

  Future<void> _rate(int rating) async {
    setState(() => _myRating = rating);
    await widget.onRate(rating);
  }

  Uri get _shareLink =>
      DeepLinks.shareLink('/services/apps/${widget.app.slug}/run');

  Future<void> _showQr() async {
    final l10n = context.l10n;
    await showNinjaDialog<void>(
      context,
      maxWidth: 320,
      builder: (dialogContext) {
        final colors = dialogContext.ninja;
        return Container(
          padding: const .all(22),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: .circular(AppRadius.dialog),
          ),
          child: Column(
            mainAxisSize: .min,
            children: [
              Text(
                widget.app.name,
                style: AppText.heading.copyWith(color: colors.ink),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              Container(
                padding: const .all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: .circular(AppRadius.full),
                ),
                child: QrImageView(data: '$_shareLink', size: 200),
              ),
              const SizedBox(height: AppSpacing.gap),
              Text(
                l10n.miniAppsQrHint,
                textAlign: .center,
                style: AppText.subtext.copyWith(color: colors.muted),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _togglePermission(
    MiniAppPermission permission, {
    required bool granted,
  }) async {
    setState(() {
      if (granted) {
        _granted.add(permission);
      } else {
        _granted.remove(permission);
      }
    });
    await widget.onPermissionsChanged?.call(_granted.toList());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final app = widget.app;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        if (app.description.isNotEmpty) ...[
          Text(
            app.description,
            style: AppText.subtext.copyWith(color: colors.ink, height: 1.5),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
        ],
        Text(
          [
            miniAppCategoryLabel(context, app.category),
            l10n.miniAppsLaunches(app.launchCount),
            if (app.ratingCount > 0)
              '${app.ratingAvg.toStringAsFixed(1)} (${app.ratingCount})',
            'v${app.version}',
          ].join(' · '),
          style: AppText.captionSmall.copyWith(color: colors.muted),
        ),
        const SizedBox(height: 18),
        Text(
          l10n.miniAppsRate,
          style: AppText.captionSmall.copyWith(color: colors.muted),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          spacing: 6,
          children: [
            for (var star = 1; star <= 5; star++)
              AppPressable(
                onTap: () => unawaited(_rate(star)),
                semanticsLabel: '$star',
                semanticsSelected: star == _myRating,
                child: SizedBox.square(
                  dimension: AppControlSize.touchTarget,
                  child: Center(
                    child: AppLineIconWidget(
                      .star,
                      size: 26,
                      color: star <= _myRating ? colors.accent : colors.muted2,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: NinjaButton.secondary(
                label: l10n.miniAppsQr,
                size: .small,
                expanded: true,
                icon: AppLineIconWidget(
                  .qr,
                  size: AppIconSize.xs,
                  color: colors.ink,
                ),
                onPressed: () => unawaited(_showQr()),
              ),
            ),
            Expanded(
              child: NinjaButton.secondary(
                label: l10n.miniAppsShare,
                size: .small,
                expanded: true,
                icon: AppLineIconWidget(
                  .share,
                  size: AppIconSize.xs,
                  color: colors.ink,
                ),
                onPressed: () => unawaited(
                  SharePlus.instance.share(
                    ShareParams(text: _shareLink.toString()),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (widget.onPermissionsChanged != null &&
            widget.app.requestedPermissions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.screen),
          Text(
            l10n.miniAppsPermissionsSection,
            style: AppText.captionSmall.copyWith(color: colors.muted),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final permission in widget.app.requestedPermissions)
            MiniAppPermissionRow(
              permission: permission,
              value: _granted.contains(permission),
              onChanged: (granted) => unawaited(
                _togglePermission(permission, granted: granted),
              ),
            ),
        ],
      ],
    );
  }
}
