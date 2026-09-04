import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class PromoContactCard extends StatelessWidget {
  const PromoContactCard({
    required this.title,
    required this.handle,
    required this.actionLabel,
    required this.onTap,
    super.key,
    this.subtitle,
  });

  final String title;
  final String handle;
  final String actionLabel;
  final VoidCallback onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (subtitle != null && subtitle.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(
                subtitle,
                style: AppText.subtext.copyWith(color: context.colors.muted),
              ),
            ),
          AppTelegramLinkCard(
            title: title,
            handle: handle,
            actionLabel: actionLabel,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
