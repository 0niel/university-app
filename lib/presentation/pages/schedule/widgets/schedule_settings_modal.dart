import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/pages/schedule/widgets/autocomplete_group_selector.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
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
                  isFirstRun ? "Настройте расписание" : "Выберите группу",
                  style: DarkTextTheme.h5,
                ),
                const SizedBox(height: 8),
                Text(
                  isFirstRun
                      ? "Кажется, что это ваш первый запуск. Установите вашу учебную группу, чтобы начать пользоваться расписанием"
                      : "Введите название группы, для которой вы хотите скачать расписание",
                  style: DarkTextTheme.captionL
                      .copyWith(color: DarkThemeColors.deactive),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      "Ваша группа".toUpperCase(),
                      style: DarkTextTheme.chip
                          .copyWith(color: DarkThemeColors.deactiveDarker),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
                const SizedBox(height: 8),
                const AutocompleteGroupSelector(),
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
                      context
                          .read<ScheduleBloc>()
                          .add(const ScheduleSetActiveGroupEvent());
                    },
                    child: Text(
                      'Начать',
                      style: DarkTextTheme.buttonS,
                    ),
                  ),
                ),
              ],
            ),
            decoration: const BoxDecoration(
              color: DarkThemeColors.background01,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0)),
            ),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.95,
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
      ),
    );
  }
}
