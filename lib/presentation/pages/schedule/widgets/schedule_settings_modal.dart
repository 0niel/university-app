import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/presentation/widgets/keyboard_positioned.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class ScheduleSettingsModal extends StatelessWidget {
  const ScheduleSettingsModal({Key? key, required this.isFirstRun})
      : super(key: key);

  final bool isFirstRun;

  @override
  Widget build(BuildContext context) {
    return KeyboardPositioned(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.colors.secondary,
              AppTheme.colors.deactive,
              AppTheme.colors.background01
            ],
            begin: const Alignment(-1, -1),
            end: const Alignment(-1, 1),
          ),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: AppTheme.colors.background01,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Image(
                    image: AssetImage('assets/images/Saly-25.png'),
                    height: 125.0,
                  ),
                ),
                Text(
                  "Настройте расписание",
                  style: AppTextStyle.h5,
                ),
                const SizedBox(height: 8),
                Text(
                  "Кажется, что это ваш первый запуск. Установите вашу учебную группу, чтобы начать пользоваться расписанием",
                  style: AppTextStyle.captionL
                      .copyWith(color: AppTheme.colors.deactive),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(
                      width: double.infinity, height: 48),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppTheme.colors.primary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      // Close modal
                      Navigator.of(context).pop();

                      context.go('/schedule/select-group');
                    },
                    child: Text(
                      'Начать',
                      style: AppTextStyle.buttonS,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
