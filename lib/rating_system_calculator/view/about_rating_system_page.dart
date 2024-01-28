import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/rating_system_calculator/rating_system_calculator.dart';
import 'package:unicons/unicons.dart';

class AboutRatingSystemPage extends StatelessWidget {
  const AboutRatingSystemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.background01,
      appBar: AppBar(
        backgroundColor: AppTheme.colors.background01,
        title: const Text(
          "О БРС",
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: RatingSystemCalculatorView(),
        ),
      ),
    );
  }
}

class RatingSystemCalculatorView extends StatefulWidget {
  const RatingSystemCalculatorView({super.key});

  @override
  State<RatingSystemCalculatorView> createState() => _RatingSystemCalculatorViewState();
}

class _RatingSystemCalculatorViewState extends State<RatingSystemCalculatorView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Text("Баллы", style: AppTextStyle.h4),
              const SizedBox(height: 16),
              Text(
                "Баллы — это единица измерения успеваемости студента. Они начисляются за выполнение академических требований в рамках учебного плана.",
                style: AppTextStyle.body,
              ),
              const ShortDescriptionCard(
                icon: UniconsSolid.check_circle,
                text: 'Максимальное количество баллов - 90',
              ),
              const ShortDescriptionCard(
                icon: UniconsSolid.exclamation_circle,
                text: 'Полученные баллы можно будет увидеть в СДО по каждой дисциплине',
              ),
              const SizedBox(height: 24),
              Text("Основные баллы", style: AppTextStyle.h6),
              Text(
                "максимум 30",
                style: AppTextStyle.body.copyWith(
                  color: AppTheme.colors.primary,
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: AppTextStyle.body.copyWith(
                    color: AppTheme.colors.active,
                  ),
                  children: [
                    const TextSpan(text: 'Выставляются за выполненеие '),
                    TextSpan(
                      text: 'обязательных заданий на аудиторных практических занятиях',
                      style: AppTextStyle.body.copyWith(
                        color: AppTheme.colors.primary,
                      ),
                    ),
                    const TextSpan(
                        text:
                            ' (контрольные работы, лабораторные и т.д.)\n\nВыставляет преподаватель, ведущий практические занятия.\n\nВ начале семестра преподаватель должен объявить за что и сколько основных баллов можно будет получить в течение семестра.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text("Баллы за работу на занятиях", style: AppTextStyle.h6),
              Text(
                "максимум 30",
                style: AppTextStyle.body.copyWith(
                  color: AppTheme.colors.primary,
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: AppTextStyle.body.copyWith(
                    color: AppTheme.colors.active,
                  ),
                  children: [
                    const TextSpan(text: 'Выставляются за '),
                    TextSpan(
                      text: 'посещаемость и активность на занятиях',
                      style: AppTextStyle.body.copyWith(
                        color: AppTheme.colors.primary,
                      ),
                    ),
                    const TextSpan(
                        text:
                            '.\n\nВыставляет лектор или преподаватель, ведущий практические занятия.\n\nВ начале семестра лектор и семинарист должны объявить за что и сколько баллов можно будет получить в течение семестра.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text("Дополнительные баллы", style: AppTextStyle.h6),
              Text(
                "максимум 30",
                style: AppTextStyle.body.copyWith(
                  color: AppTheme.colors.primary,
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: AppTextStyle.body.copyWith(
                    color: AppTheme.colors.active,
                  ),
                  children: [
                    const TextSpan(text: 'Выставляются за выполнение '),
                    TextSpan(
                      text: 'тестовых заданий в СДО',
                      style: AppTextStyle.body.copyWith(
                        color: AppTheme.colors.primary,
                      ),
                    ),
                    const TextSpan(
                        text:
                            '.\n\nВыставляет преподаватель, ведущий практические занятия.\n\nВ начале семестра преподаватель должен объявить за что и сколько дополнительных баллов можно будет получить в течение семестра.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text("Что дают баллы", style: AppTextStyle.h6),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: AppTextStyle.body.copyWith(
                    color: AppTheme.colors.active,
                  ),
                  children: [
                    const TextSpan(text: '1. Если общая '),
                    TextSpan(
                      text: 'сумма баллов 60 и более',
                      style: AppTextStyle.body.copyWith(
                        color: AppTheme.colors.primary,
                      ),
                    ),
                    const TextSpan(
                      text: ', можно автоматически получить зачет или оценку «удовлетворительно» на экзамене.\n\n',
                    ),
                    const TextSpan(
                      text:
                          '2. На экзамене можно получить оценки выше, чем «удовлетворительно», однако из баллов, полученных в течение семестра, учитываются только основные баллы (макс. 30 баллов), а ещё 60 баллов можно получить за ответы на экзамене.\n\n',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text("Таблица баллов", style: AppTextStyle.h6),
              const SizedBox(height: 16),
              const ScoresTable(),
            ],
          ),
        ),
      ],
    );
  }
}
