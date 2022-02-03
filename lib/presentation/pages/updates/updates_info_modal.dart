import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/colorful_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_button.dart';

abstract class UpdatesInfoModal {
  static void checkAndShow(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const UpdatesInfo(),
    );
  }
}

class UpdatesInfo extends StatelessWidget {
  const UpdatesInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(25.0),
      )),
      child: Material(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        )),
        child: Container(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: 24,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'обновление',
                  style: DarkTextTheme.captionS.copyWith(
                    color: DarkThemeColors.deactive,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 16)),
                Text(
                  'Вход в СДО 😱',
                  textAlign: TextAlign.center,
                  style: DarkTextTheme.h5,
                ),
                const Padding(padding: EdgeInsets.only(top: 24)),
                Text(
                  'Откройте страницу Профиля, чтобы всё увидеть 👀',
                  style: DarkTextTheme.bodyL,
                ),
                const Padding(padding: EdgeInsets.only(top: 24)),
                Container(
                  constraints: const BoxConstraints(
                    minHeight: 0,
                    minWidth: double.infinity,
                    maxHeight: 150,
                  ),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Text(
                        """
Подробный change log:

* Добавлены виджеты рабочего стола
* Добавлен профиль с интеграцией ЛК МИРЭА
* Добавлены сторисы на страницу новостей
* Добавлены важные новости на страницу новостей
* Добавлен фильтр тегов на странице новостей
* Изменена система навигации приложения
* Множество других изменение, исправлений и улучшений
""",
                        style: DarkTextTheme.body.copyWith(
                          color: DarkThemeColors.deactive,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                ),
                PrimaryButton(
                  text: 'Класс!',
                  onClick: () => Navigator.pop(context),
                  // backgroundColor: DarkThemeColors.primary,
                ),
                const Padding(padding: EdgeInsets.only(top: 24)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Ваша версия приложения - 1.2.0',
                      style: DarkTextTheme.captionL,
                    ),
                  ],
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2.5,
              color: DarkThemeColors.secondary,
            ),
            color: DarkThemeColors.background03,
            borderRadius: const BorderRadius.all(
              Radius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }
}
