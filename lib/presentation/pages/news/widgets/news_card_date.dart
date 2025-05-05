import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:intl/intl.dart';

class NewsCardDate extends StatelessWidget {
  final DateTime date;

  const NewsCardDate({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: colors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(50)),
      child: Text(
        DateFormat.yMMMd('ru_RU').format(date),
        style: AppTextStyle.captionS.copyWith(color: colors.primary, fontWeight: FontWeight.w600),
      ),
    );
  }
}
