import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class PeopleColdError extends StatelessWidget {
  const PeopleColdError({
    required this.onRetry,
    super.key,
    this.studyGroupOnly = false,
  });

  final Future<bool> Function() onRetry;
  final bool studyGroupOnly;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const .all(24),
      children: [
        NinjaErrorState(
          title: studyGroupOnly
              ? l10n.peopleGroupLoadError
              : l10n.peopleLoadError,
          message: studyGroupOnly
              ? l10n.peopleGroupLoadErrorSubtitle
              : l10n.peopleLoadErrorSubtitle,
          icon: AppLineIconWidget(
            AppLineIcon.alert,
            size: 20,
            color: context.ninja.scarlet,
          ),
          retryLabel: l10n.retry,
          onRetry: () => unawaited(onRetry()),
        ),
      ],
    );
  }
}
