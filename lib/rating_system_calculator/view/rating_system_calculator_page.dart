import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/text_outlined_button.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';

class RatingSystemCalculatorPage extends StatelessWidget {
  const RatingSystemCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.background01,
      appBar: AppBar(
        backgroundColor: AppTheme.colors.background01,
        elevation: 0,
        title: const Text(
          "Бально-рейтинговая система",
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: RatingSystemCalculatorView(),
        ),
      ),
    );
  }
}

class RatingSystemCalculatorView extends StatefulWidget {
  const RatingSystemCalculatorView({super.key});

  @override
  State<RatingSystemCalculatorView> createState() =>
      _RatingSystemCalculatorViewState();
}

class _RatingSystemCalculatorViewState
    extends State<RatingSystemCalculatorView> {
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
    final scheduleBloc = context.watch<ScheduleBloc>();

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                decoration: ShapeDecoration(
                  gradient: const LinearGradient(
                    stops: [0.1, 0.3, 0.7, 0.9],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF85FF99),
                      Color(0xFF87BFFB),
                      Color(0xFFBD9DFE),
                      Color(0xFFFFB8DF),
                    ],
                    transform: GradientRotation(0.5 * 3.14),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Бально-рейтинговая система",
                      style: AppTextStyle.titleM.copyWith(
                        color: AppTheme.colors.activeLightMode,
                        fontWeight: FontWeight.w700,
                        fontSize: 21,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "📖  Перейдите, чтобы узнать, как это устроено",
                            style: AppTextStyle.bodyL.copyWith(
                              color: AppTheme.colors.activeLightMode,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      text: "Подробнее",
                      onClick: () {
                        context.go('/services/rating-system-calculator/about');
                      },
                    ),
                  ],
                ),
              ).animate().slideX(
                    duration: 400.ms,
                    begin: -1.5,
                    end: 0,
                  ),
              const SizedBox(height: 32),
              SubjectsListView(
                selectedSchedule: scheduleBloc.state.selectedSchedule,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SubjectsListView extends StatelessWidget {
  const SubjectsListView({Key? key, this.selectedSchedule}) : super(key: key);

  final SelectedSchedule? selectedSchedule;

  @override
  Widget build(BuildContext context) {
    if (selectedSchedule is SelectedGroupSchedule) {
      return Column(
        children: [
          Card(
            color: AppTheme.colors.background02,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF9ADB7F),
                          Color(0xFF6EA95C),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.school,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Математический анализ",
                      style: AppTextStyle.buttonL.copyWith(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Text(
                      "32",
                      style: AppTextStyle.buttonL.copyWith(
                        color: AppTheme.colors.colorful05,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
          Card(
            color: AppTheme.colors.background02,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppTheme.colors.colorful02,
                    ),
                    child: Icon(
                      Icons.school,
                      color: AppTheme.colors.activeLightMode,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Линейная алгебра",
                      style: AppTextStyle.buttonL.copyWith(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Text(
                      "8",
                      style: AppTextStyle.buttonL.copyWith(
                        color: AppTheme.colors.colorful02,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          )
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "У вас не выбрано расписание Группы!",
              style: AppTextStyle.titleM,
            ),
            const SizedBox(height: 16),
            Text(
              "Выберите расписание, на основе которого мы отобразим для вас предметы",
              style: AppTextStyle.body,
            ),
            const SizedBox(height: 24),
            TextOutlinedButton(
              content: "Выбрать расписание",
              onPressed: () {
                context.go('/schedule');
              },
            ),
          ],
        ),
      );
    }
  }
}
