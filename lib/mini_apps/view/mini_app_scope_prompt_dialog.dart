import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_labels.dart';

class MiniAppScopePromptDialog extends StatelessWidget {
  const MiniAppScopePromptDialog({required this.scope, super.key});

  final MiniAppPermission scope;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return NinjaDialog(
      title: miniAppPermissionLabel(context, scope),
      message: miniAppPermissionDescription(context, scope),
      cancelLabel: l10n.miniAppsScopeNotNow,
      onCancel: () => Navigator.of(context).pop(false),
      confirmLabel: l10n.miniAppsConsentAllow,
      onConfirm: () => Navigator.of(context).pop(true),
    );
  }
}
