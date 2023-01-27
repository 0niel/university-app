import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/core/routes/routes.gr.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/keyboard_positioned.dart';

class ScheduleSettingsModal extends StatelessWidget {
  const ScheduleSettingsModal({Key? key, required this.isFirstRun})
      : super(key: key);

  final bool isFirstRun;

  @override
  Widget build(BuildContext context) {
    return KeyboardPositioned(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              DarkThemeColors.secondary,
              DarkThemeColors.deactive,
              DarkThemeColors.background01
            ],
            begin: Alignment(-1, -1),
            end: Alignment(-1, 1),
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              color: DarkThemeColors.background01,
              borderRadius: BorderRadius.only(
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
                  style: DarkTextTheme.h5,
                ),
                const SizedBox(height: 8),
                Text(
                  "Кажется, что это ваш первый запуск. Установите вашу учебную группу, чтобы начать пользоваться расписанием",
                  style: DarkTextTheme.captionL
                      .copyWith(color: DarkThemeColors.deactive),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(
                      width: double.infinity, height: 48),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(DarkThemeColors.primary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      // Close modal
                      Navigator.of(context).pop();

                      context.router.push(const GroupsSelectRoute());
                    },
                    child: Text(
                      'Начать',
                      style: DarkTextTheme.buttonS,
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
