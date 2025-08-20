import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class DesktopNoScheduleView extends StatelessWidget {
  const DesktopNoScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(color: colors.primary.withOpacity(0.1), shape: BoxShape.circle),
              child: Center(child: HugeIcon(icon: HugeIcons.strokeRoundedAdd01, size: 50, color: colors.primary)),
            ),
            const SizedBox(height: 32),
            Text(
              context.l10n.noScheduleSelected,
              style: AppTextStyle.h6.copyWith(fontWeight: FontWeight.bold, color: colors.active),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 400,
              child: Text(
                context.l10n.selectEntityToSeeSchedule,
                style: AppTextStyle.bodyL.copyWith(color: colors.deactive, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                context.go('/schedule/search');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.search, color: Colors.white),
              label: Text(context.l10n.findSchedule),
            ),
          ],
        ),
      ),
    );
  }
}
