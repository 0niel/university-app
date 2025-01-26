import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class ScoresTable extends StatelessWidget {
  const ScoresTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: AppColors.dark.primary.withOpacity(0.2),
      ),
      children: [
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Баллы",
                  style: AppTextStyle.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Оценка",
                  style: AppTextStyle.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "85+",
                  style: AppTextStyle.body.copyWith(
                    color: AppColors.dark.colorful05,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "5",
                  style: AppTextStyle.body.copyWith(
                    color: AppColors.dark.colorful05,
                  ),
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "70-84",
                  style: AppTextStyle.body.copyWith(
                    color: AppColors.dark.colorful01,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "4",
                  style: AppTextStyle.body.copyWith(
                    color: AppColors.dark.colorful01,
                  ),
                ),
              ),
            ),
          ],
        ),
        TableRow(children: [
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "60-69",
                style: AppTextStyle.body.copyWith(
                  color: AppColors.dark.colorful07,
                ),
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "3 (зачет)",
                style: AppTextStyle.body.copyWith(
                  color: AppColors.dark.colorful07,
                ),
              ),
            ),
          ),
        ]),
      ],
    );
  }
}
