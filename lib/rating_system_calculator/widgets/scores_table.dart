import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class ScoresTable extends StatelessWidget {
  const ScoresTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: AppTheme.colors.primary.withOpacity(0.2),
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
                    color: AppTheme.colors.colorful05,
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
                    color: AppTheme.colors.colorful05,
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
                    color: AppTheme.colors.colorful01,
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
                    color: AppTheme.colors.colorful01,
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
                  color: AppTheme.colors.colorful07,
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
                  color: AppTheme.colors.colorful07,
                ),
              ),
            ),
          ),
        ]),
      ],
    );
  }
}
