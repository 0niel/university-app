import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

class ScheduleDiffPage extends StatelessWidget {
  final ScheduleDiff diff;

  const ScheduleDiffPage({super.key, required this.diff});

  Widget _iconForType(ChangeType type) {
    switch (type) {
      case ChangeType.added:
        return HugeIcon(icon: HugeIcons.strokeRoundedMinusPlusSquare01, size: 24, color: AppColors.light.colorful04);
      case ChangeType.removed:
        return HugeIcon(icon: HugeIcons.strokeRoundedPlusMinusSquare01, size: 24, color: AppColors.light.colorful07);
      case ChangeType.modified:
        return HugeIcon(icon: HugeIcons.strokeRoundedTaskEdit01, size: 24, color: AppColors.light.colorful06);
    }
  }

  String _prefixForType(ChangeType type) {
    switch (type) {
      case ChangeType.added:
        return '+';
      case ChangeType.removed:
        return '–';
      case ChangeType.modified:
        return '~';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<ScheduleChange> changesList = diff.changes.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Изменения в расписании'),
        actions: [IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop())],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: changesList.length,
          itemBuilder: (context, index) {
            final change = changesList[index];
            final icon = _iconForType(change.type);
            final typePrefix = _prefixForType(change.type);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      icon,
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$typePrefix ${change.subject}',
                          style: AppTextStyle.bodyBold.copyWith(color: (icon as HugeIcon).color),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ...change.fieldDiffs.map((fieldDiff) {
                    if (fieldDiff.fieldName == 'Даты' && fieldDiff.addedDates != null) {
                      List<Widget> dateWidgets = [];
                      // Removed dates
                      if ((fieldDiff.removedDates?.isNotEmpty ?? false)) {
                        for (var date in fieldDiff.removedDates!) {
                          dateWidgets.add(
                            Text(
                              '- ${DateFormat("dd.MM").format(date)}',
                              style: AppTextStyle.body.copyWith(color: AppColors.light.colorful07),
                            ),
                          );
                        }
                      }
                      // Unchanged dates
                      if ((fieldDiff.unchangedDates?.isNotEmpty ?? false)) {
                        for (var date in fieldDiff.unchangedDates!) {
                          dateWidgets.add(
                            Text(
                              DateFormat("dd.MM").format(date),
                              style: AppTextStyle.body.copyWith(color: Colors.grey[600]),
                            ),
                          );
                        }
                      }
                      // Added dates
                      if ((fieldDiff.addedDates?.isNotEmpty ?? false)) {
                        for (var date in fieldDiff.addedDates!) {
                          dateWidgets.add(
                            Text(
                              '+ ${DateFormat("dd.MM").format(date)}',
                              style: AppTextStyle.body.copyWith(color: AppColors.light.colorful04),
                            ),
                          );
                        }
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Text('${fieldDiff.fieldName}:', style: AppTextStyle.bodyBold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Wrap(spacing: 12.0, runSpacing: 4.0, children: dateWidgets),
                          ),
                        ],
                      );
                    } else {
                      // For non-date fields
                      if (change.type == ChangeType.added) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 32.0, bottom: 2.0),
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyle.body.copyWith(fontSize: 14),
                              children: [
                                TextSpan(text: '${fieldDiff.fieldName}: ', style: AppTextStyle.bodyBold),
                                TextSpan(
                                  text: '+ ${fieldDiff.newValue}',
                                  style: AppTextStyle.body.copyWith(color: AppColors.light.colorful04),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (change.type == ChangeType.removed) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 32.0, bottom: 2.0),
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyle.body.copyWith(fontSize: 14),
                              children: [
                                TextSpan(text: '${fieldDiff.fieldName}: ', style: AppTextStyle.bodyBold),
                                TextSpan(
                                  text: '– ${fieldDiff.oldValue}',
                                  style: AppTextStyle.body.copyWith(color: AppColors.light.colorful07),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(left: 32.0, bottom: 2.0),
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyle.body.copyWith(fontSize: 14),
                              children: [
                                TextSpan(text: '${fieldDiff.fieldName}: ', style: AppTextStyle.bodyBold),
                                TextSpan(
                                  text: '- ${fieldDiff.oldValue}',
                                  style: AppTextStyle.body.copyWith(color: AppColors.light.colorful07),
                                ),
                                const TextSpan(text: '  →  '),
                                TextSpan(
                                  text: '+ ${fieldDiff.newValue}',
                                  style: AppTextStyle.body.copyWith(color: AppColors.light.colorful04),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  }),
                  const Divider(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
