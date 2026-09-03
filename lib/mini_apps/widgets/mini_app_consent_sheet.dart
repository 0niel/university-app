import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_labels.dart';

part 'mini_app_permission_row.dart';

class MiniAppConsentSheet extends StatefulWidget {
  const MiniAppConsentSheet({required this.app, super.key});

  final MiniApp app;

  @override
  State<MiniAppConsentSheet> createState() => _MiniAppConsentSheetState();
}

class _MiniAppConsentSheetState extends State<MiniAppConsentSheet> {
  late final Set<MiniAppPermission> _granted = {
    ...widget.app.requestedPermissions,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Text(
          l10n.miniAppsConsentBody,
          style: AppText.subtext.copyWith(color: colors.muted, height: 1.5),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        for (final permission in widget.app.requestedPermissions)
          MiniAppPermissionRow(
            permission: permission,
            value: _granted.contains(permission),
            onChanged: (granted) => setState(() {
              if (granted) {
                _granted.add(permission);
              } else {
                _granted.remove(permission);
              }
            }),
          ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.miniAppsConsentFootnote,
          style: AppText.captionSmall.copyWith(color: colors.muted),
        ),
        const SizedBox(height: AppSpacing.lg),
        NinjaButton.primary(
          label: l10n.miniAppsConsentAllow,
          expanded: true,
          onPressed: () => Navigator.of(context).pop(_granted.toList()),
        ),
        const SizedBox(height: AppSpacing.sm),
        NinjaButton.secondary(
          label: l10n.miniAppsConsentDenyAll,
          expanded: true,
          onPressed: () =>
              Navigator.of(context).pop(const <MiniAppPermission>[]),
        ),
      ],
    );
  }
}
