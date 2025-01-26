import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rtu_mirea_app/presentation/constants.dart';
import 'package:app_ui/app_ui.dart';

class NoSelectedScheduleMessage extends StatelessWidget {
  const NoSelectedScheduleMessage({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isTable = MediaQuery.of(context).size.width > tabletBreakpoint;

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: isTable ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Center(
                child: Assets.images.saly2
                    .image(height: 200)
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .rotate(
                      duration: 3000.ms,
                      begin: -0.03,
                      end: 0.03,
                      curve: Curves.easeInOut,
                    )
                    .move(
                      duration: 3000.ms,
                      begin: const Offset(0, -10),
                      end: const Offset(0, 10),
                      curve: Curves.easeInOut,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                "Не установлена активная группа",
                style: AppTextStyle.h5,
              ),
              const SizedBox(height: 8),
              Text(
                "Скачайте расписание по крайней мере для одной группы, чтобы отобразить календарь.",
                style: AppTextStyle.captionL.copyWith(
                  color: Theme.of(context).extension<AppColors>()!.deactive,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: isTable ? 420 : double.infinity,
                child: ColorfulButton(
                  text: "Настроить",
                  onClick: onTap,
                  backgroundColor: Theme.of(context).extension<AppColors>()!.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
