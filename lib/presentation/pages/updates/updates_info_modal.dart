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
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Интеграция с СДО 😱',
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
                          style: DarkTextTheme.captionL.copyWith(
                              // color: DarkThemeColors.deactive,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              decoration: const BoxDecoration(
                color: DarkThemeColors.background03,
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
            ),
          ),
          // height: MediaQuery.of(context).size.height * 0.95,
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
            borderRadius: BorderRadius.all(
              Radius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }
}
