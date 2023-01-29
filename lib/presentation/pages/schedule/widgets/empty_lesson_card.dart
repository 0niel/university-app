import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class EmptyLessonCard extends StatelessWidget {
  final String timeStart;
  final String timeEnd;

  const EmptyLessonCard({
    Key? key,
    required this.timeStart,
    required this.timeEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      color: AppTheme.colors.background03,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 55),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    timeStart,
                    style: AppTextStyle.bodyBold.copyWith(
                        color: AppTheme.colors.deactive, fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    timeEnd,
                    style: AppTextStyle.bodyBold.copyWith(
                        color: AppTheme.colors.deactive, fontSize: 12),
                  )
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  width: 25,
                  height: 1,
                  color: AppTheme.colors.deactive,
                ),
                const SizedBox(height: 20),
                Container(
                  width: 25,
                  height: 1,
                  color: AppTheme.colors.deactive,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
