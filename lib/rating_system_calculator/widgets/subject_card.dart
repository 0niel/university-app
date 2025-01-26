import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/rating_system_calculator/models/models.dart';

// Card(
//             color: AppColors.dark.background02,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 48,
//                     height: 48,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       color: AppColors.dark.colorful02,
//                     ),
//                     child: Icon(
//                       Icons.school,
//                       color: AppColors.dark.activeLightMode,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Text(
//                       "Линейная алгебра",
//                       style: AppTextStyle.buttonL.copyWith(),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(right: 18.0),
//                     child: Text(
//                       "8",
//                       style: AppTextStyle.buttonL.copyWith(
//                         color: AppColors.dark.colorful02,
//                       ),
//                     ),
//                   ),
//                   const Icon(Icons.arrow_forward_ios),
//                 ],
//               ),
//             ),
//           )

class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    required this.subject,
    required this.onTap,
  });

  final Subject subject;
  final void Function(Subject) onTap;

  double get score {
    return (subject.mainScore ?? 0) + (subject.additionalScore ?? 0) + (subject.classScore ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.dark.background02,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => onTap(subject),
        borderRadius: BorderRadius.circular(16),
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
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  subject.name,
                  style: AppTextStyle.buttonL.copyWith(
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Text(
                  score.toString(),
                  style: AppTextStyle.buttonL.copyWith(
                    color: AppColors.dark.colorful05,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
