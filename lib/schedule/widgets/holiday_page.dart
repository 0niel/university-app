import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Импортируем flutter_animate
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class HolidayPage extends StatelessWidget {
  const HolidayPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      alignment: Alignment.topLeft,
      maxWidth: double.infinity,
      maxHeight: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.saly18
              .image(height: 225.0)
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveY(begin: 0, end: -40, duration: 5000.ms, curve: Curves.easeInOut)
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.07, 1.07),
                duration: 4000.ms,
                curve: Curves.easeInOut,
              )
              .rotate(begin: 0.0349, end: -0.0349, duration: 5000.ms, curve: Curves.easeInOut),

          const SizedBox(height: 16),
          Text(title, style: AppTextStyle.title),
          const SizedBox(height: 8),
          Text(context.l10n.noLessonsThatDayShort, style: AppTextStyle.bodyL),
        ],
      ),
    );
  }
}
