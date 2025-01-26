import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/rating_system_calculator/models/models.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({
    super.key,
    required this.subject,
  });

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark.background01,
      appBar: AppBar(
        backgroundColor: AppColors.dark.background01,
        title: const Text(
          "Калькулятор",
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: RatingSystemCalculatorView(subject: subject),
        ),
      ),
    );
  }
}

class RatingSystemCalculatorView extends StatefulWidget {
  const RatingSystemCalculatorView({super.key, required this.subject});

  final Subject subject;

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
              Text(
                "Здесь вы можете сохранить свои баллы и отслеживать их в удобном формате.",
                style: AppTextStyle.body,
              ),
              const SizedBox(height: 16),
              // Кнопки с выбором посещенных дней. По нажатию на кнопку, она меняет свой цвет.
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final day in widget.subject.dates)
                    ChoiceChip(
                      label: Text(
                        day.toString().split(' ')[0],
                        style: AppTextStyle.body.copyWith(
                          color: AppColors.dark.activeLightMode,
                        ),
                      ),
                      selected: false,
                      onSelected: (value) {},
                      selectedColor: AppColors.dark.primary,
                      backgroundColor: AppColors.dark.background02,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
