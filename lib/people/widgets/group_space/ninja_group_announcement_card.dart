import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';

class NinjaGroupAnnouncementCard extends StatelessWidget {
  const NinjaGroupAnnouncementCard({required this.announcement, super.key});

  final GroupAnnouncement announcement;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const .symmetric(horizontal: AppSpacing.screen),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(AppRadius.card),
        ),
        child: Padding(
          padding: const .all(16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                announcement.title,
                style: AppText.headline.copyWith(color: colors.ink),
              ),
              if (announcement.body.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  announcement.body,
                  style: AppText.subtext.copyWith(
                    color: colors.muted,
                    height: 1.45,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
