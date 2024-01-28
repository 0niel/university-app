import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rtu_mirea_app/domain/entities/user.dart';
import 'package:rtu_mirea_app/presentation/widgets/badged_container.dart';
import 'package:rtu_mirea_app/presentation/widgets/copy_text_block.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class ProfileDetailPage extends StatelessWidget {
  const ProfileDetailPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    var student = user.students.firstWhereOrNull((element) => element.status == 'активный');
    student ??= user.students.first;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Детали профиля"),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: CircleAvatar(
                  radius: 68,
                  backgroundImage: Image.network('https://lk.mirea.ru${user.photoUrl}').image,
                ),
              ),
              const SizedBox(height: 13),
              Center(
                child: Text(
                  '${user.lastName} ${user.name} ${user.secondName}',
                  style: AppTextStyle.h6,
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
                          text: student.academicGroup,
                        ),
                      ),
                      SizedBox(
                        width: 160,
                        child: BadgedContainer(
                          label: 'Личный номер',
                          text: student.personalNumber,
                        ),
                      ),
                      SizedBox(
                        width: 160,
                        child: BadgedContainer(
                          label: 'Курс',
                          text: student.course.toString(),
                        ),
                      ),
                      SizedBox(
                        width: 160,
                        child: BadgedContainer(
                          label: 'Состояние',
                          text: student.status,
                        ),
                      ),
                    ]),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 23),
              CopyTextBlockWithLabel(label: "Логин", text: user.login),
              CopyTextBlockWithLabel(label: "Персональный email", text: user.email),
              const SizedBox(height: 23),
              CopyTextBlockWithLabel(label: "Дата рождения", text: user.birthday),
              const SizedBox(height: 23),
              CopyTextBlockWithLabel(label: "Дата начала обучения", text: student.educationStartDate),
              const SizedBox(height: 23),
              CopyTextBlockWithLabel(label: "Дата окончания обучения", text: student.educationEndDate),
              const SizedBox(height: 23),
              CopyTextBlockWithLabel(label: "Дата регистрации", text: user.registerDate),
              const SizedBox(height: 23),
              CopyTextBlockWithLabel(label: "Формирующее подразделение", text: student.eduProgram.department),
              const SizedBox(height: 23),
              CopyTextBlockWithLabel(label: "Выпускающее подразделение", text: student.eduProgram.prodDepartment),
              const SizedBox(height: 23),
              CopyTextBlockWithLabel(
                  label: "Направление подготовки (специальность)", text: student.eduProgram.eduProgram),
              const SizedBox(height: 23),
              CopyTextBlockWithLabel(label: "Код направления", text: student.eduProgram.eduProgramCode),
              const SizedBox(height: 23),
              CopyTextBlockWithLabel(label: "Вид образовательной программы", text: student.eduProgram.type ?? ""),
            ],
          ),
        ),
      ),
    );
  }
}
