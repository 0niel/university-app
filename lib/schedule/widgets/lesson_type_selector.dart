import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:university_app_server_api/client.dart';

class LessonTypeSelector extends StatelessWidget {
  const LessonTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
    this.label = 'Тип занятия',
  });

  final LessonType selectedType;
  final Function(LessonType) onTypeSelected;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    // Типы занятий с иконками, названиями и цветами
    final lessonTypes = [
      (LessonType.practice, 'Практика', colors.colorful01, HugeIcons.strokeRoundedDocumentAttachment),
      (LessonType.lecture, 'Лекция', colors.colorful02, HugeIcons.strokeRoundedTeaching),
      (LessonType.laboratoryWork, 'Лабораторная', colors.colorful03, HugeIcons.strokeRoundedEcoLab01),
      (LessonType.individualWork, 'Индивидуальная', colors.colorful04, HugeIcons.strokeRoundedUserCircle),
      (LessonType.physicalEducation, 'Физкультура', colors.colorful05, HugeIcons.strokeRoundedWorkoutGymnastics),
      (LessonType.consultation, 'Консультация', colors.colorful06, HugeIcons.strokeRoundedMessage01),
      (LessonType.exam, 'Экзамен', colors.colorful07, HugeIcons.strokeRoundedGivePill),
      (LessonType.credit, 'Зачет', colors.success, HugeIcons.strokeRoundedTick01),
      (LessonType.courseWork, 'Курсовая работа', colors.info, HugeIcons.strokeRoundedBook02),
      (LessonType.courseProject, 'Курсовой проект', colors.accent, HugeIcons.strokeRoundedDocumentCode),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.titleS.copyWith(color: colors.active, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),

        // Сетка с типами занятий
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: lessonTypes.length,
          itemBuilder: (context, index) {
            final (type, name, color, icon) = lessonTypes[index];
            final isSelected = selectedType == type;

            return Material(
              color: isSelected ? color.withOpacity(0.15) : colors.background01,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => onTypeSelected(type),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? color : colors.background03, width: isSelected ? 1.5 : 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                        child: Center(child: Icon(icon, size: 20, color: color)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          name,
                          style: AppTextStyle.body.copyWith(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? color : colors.active,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isSelected) Icon(Icons.check_circle, size: 16, color: color),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
