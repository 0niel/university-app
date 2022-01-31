import 'package:flutter/material.dart';

import 'package:rtu_mirea_app/domain/entities/user.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/badged_container.dart';
import 'package:rtu_mirea_app/presentation/widgets/copy_text_block.dart';

class ProfileDetailPage extends StatelessWidget {
  const ProfileDetailPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Детали профиля"),
        backgroundColor: DarkThemeColors.background01,
      ),
      backgroundColor: DarkThemeColors.background01,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: CircleAvatar(
                    radius: 68,
                    backgroundImage:
                        Image.network('https://lk.mirea.ru' + user.photoUrl)
                            .image,
                  ),
                ),
                const SizedBox(height: 13),
                Center(
                  child: Text(
                    user.name + ' ' + user.secondName + ' ' + user.lastName,
                    style: DarkTextTheme.h6,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                      runSpacing: 8.0,
                      alignment: WrapAlignment.spaceEvenly,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 160,
                          child: BadgedContainer(
                              label: 'Группа',
                              text: user.academicGroup,
                              onClick: () {}),
                        ),
                        SizedBox(
                          width: 160,
                          child: BadgedContainer(
                              label: 'Личный номер',
                              text: user.personalNumber,
                              onClick: () {}),
                        ),
                        SizedBox(
                          width: 160,
                          child: BadgedContainer(
                              label: 'Курс',
                              text: user.course.toString(),
                              onClick: () {}),
                        ),
                        SizedBox(
                          width: 160,
                          child: BadgedContainer(
                              label: 'Состояние',
                              text: user.isActive ? 'активный' : 'неактивный',
                              onClick: () {}),
                        ),
                      ]),
                ),
                const SizedBox(height: 20),
                if (user.authShortlink != null)
                  CopyTextBlockWithLabel(
                      label: "Ссылка авторизации",
                      text: 'https://lk.mirea.ru/auth/link/?url=' +
                          user.authShortlink!),
                const SizedBox(height: 23),
                CopyTextBlockWithLabel(label: "Логин", text: user.login),
                const SizedBox(height: 23),
                CopyTextBlockWithLabel(
                    label: "Персональный email", text: user.email),
                const SizedBox(height: 23),
                CopyTextBlockWithLabel(
                    label: "Дата рождения", text: user.birthday),
                const SizedBox(height: 23),
                CopyTextBlockWithLabel(
                    label: "Дата начала обучения",
                    text: user.educationStartDate),
                const SizedBox(height: 23),
                CopyTextBlockWithLabel(
                    label: "Дата окончания обучения",
                    text: user.educationEndDate),
                const SizedBox(height: 23),
                CopyTextBlockWithLabel(
                    label: "Дата регистрации", text: user.registerDate),
                const SizedBox(height: 23),
                CopyTextBlockWithLabel(
                    label: "Последний вход", text: user.lastLoginDate),
                const SizedBox(height: 23),
                CopyTextBlockWithLabel(
                    label: "Формирующее подразделение", text: user.department),
                const SizedBox(height: 23),
                CopyTextBlockWithLabel(
                    label: "Выпускающее подразделение",
                    text: user.prodDepartment),
                const SizedBox(height: 23),
                CopyTextBlockWithLabel(
                    label: "Направление подготовки (специальность)",
                    text: user.eduProgram),
                const SizedBox(height: 23),
                CopyTextBlockWithLabel(
                    label: "Код направления", text: user.eduProgramCode),
                const SizedBox(height: 23),
                CopyTextBlockWithLabel(
                    label: "Вид образовательной программы", text: user.type),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
