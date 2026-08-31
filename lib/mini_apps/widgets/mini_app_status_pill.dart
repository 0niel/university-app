import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_labels.dart';

class MiniAppStatusPill extends StatelessWidget {
  const MiniAppStatusPill({required this.status, super.key});

  final MiniAppStatus status;

  @override
  Widget build(BuildContext context) {
    final tone = switch (status) {
      MiniAppStatus.rejected ||
      MiniAppStatus.suspended => NinjaBadgeTone.dangerOutline,
      MiniAppStatus.published ||
      MiniAppStatus.pendingReview ||
      MiniAppStatus.draft => NinjaBadgeTone.ink,
    };
    return NinjaBadge(miniAppStatusLabel(context, status), tone: tone);
  }
}
