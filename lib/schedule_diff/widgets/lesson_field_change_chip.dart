import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule_diff/widgets/field_info.dart';
import 'package:schedule/schedule.dart';

class LessonFieldChangeChip extends StatelessWidget {
  const LessonFieldChangeChip({required this.change, super.key});
  final LessonFieldChange change;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final scale = Theme.of(context).scale;
    final info = fieldInfo(change.field, context.l10n, colors);
    return Container(
      padding: .all(scale.space(12)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Container(
                width: scale.size(24),
                height: scale.size(24),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: info.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: AppLineIconWidget(
                  info.icon,
                  color: info.color,
                  size: scale.icon(15),
                ),
              ),
              SizedBox(width: scale.space(12)),
              Text(
                info.label,
                style: NinjaText.subtext.copyWith(
                  color: colors.ink,
                  fontWeight: .w600,
                ),
              ),
            ],
          ),
          SizedBox(height: scale.space(12)),
          _buildChangeContent(context, change),
        ],
      ),
    );
  }

  Widget _buildChangeContent(
    BuildContext context,
    LessonFieldChange fieldChange,
  ) {
    final colors = context.ninja;
    final scale = Theme.of(context).scale;
    if (fieldChange.field == .dates) {
      final addedDates = fieldChange.addedDates;
      final removedDates = fieldChange.removedDates;
      final hasAdded = addedDates != null && addedDates.isNotEmpty;
      final hasRemoved = removedDates != null && removedDates.isNotEmpty;
      return Column(
        crossAxisAlignment: .start,
        children: [
          if (hasAdded)
            _buildDatesList(
              context,
              'Добавлены даты',
              addedDates,
              colors.green,
              AppLineIcon.plus,
            ),
          if (hasAdded && hasRemoved) SizedBox(height: scale.space(12)),
          if (hasRemoved)
            _buildDatesList(
              context,
              'Удалены даты',
              removedDates,
              colors.scarlet,
              AppLineIcon.trash,
            ),
        ],
      );
    }

    final oldValue = fieldChange.oldValue;
    final newValue = fieldChange.newValue;
    if (oldValue != null && newValue != null) {
      return Column(
        crossAxisAlignment: .start,
        children: [
          _buildValue(context, 'Было', oldValue, colors.scarlet),
          SizedBox(height: scale.space(8)),
          _buildValue(context, 'Стало', newValue, colors.green),
        ],
      );
    }

    final value = fieldChange.newValue ?? fieldChange.oldValue ?? '';
    if (value.isNotEmpty) {
      return _buildValue(
        context,
        fieldChange.newValue != null ? 'Значение' : 'Было',
        value,
        fieldChange.newValue != null ? colors.green : colors.scarlet,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildDatesList(
    BuildContext context,
    String label,
    List<DateTime> dates,
    Color color,
    AppLineIcon icon,
  ) {
    final colors = context.ninja;
    final scale = Theme.of(context).scale;
    return Container(
      padding: .all(scale.space(12)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(scale.radius(8)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              AppLineIconWidget(
                icon,
                color: color,
                size: scale.icon(12),
              ),
              SizedBox(width: scale.space(8)),
              Text(
                label,
                style: NinjaText.helper.copyWith(
                  color: color,
                  fontWeight: .w600,
                ),
              ),
            ],
          ),
          SizedBox(height: scale.space(8)),
          Wrap(
            spacing: scale.space(8),
            runSpacing: scale.space(8),
            children: dates
                .map(
                  (d) => Container(
                    padding: .symmetric(
                      horizontal: scale.space(8),
                      vertical: scale.space(4),
                    ),
                    decoration: BoxDecoration(
                      color: colors.canvas,
                      borderRadius: .circular(scale.radius(4)),
                    ),
                    child: Text(
                      formatDiffDate(
                        d,
                        Localizations.localeOf(context).languageCode,
                      ),
                      style: NinjaText.helper.copyWith(
                        color: colors.ink,
                        fontWeight: .w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildValue(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final colors = context.ninja;
    final scale = Theme.of(context).scale;
    return Row(
      crossAxisAlignment: .start,
      children: [
        Container(
          width: scale.size(4),
          height: scale.size(4),
          margin: .only(top: scale.space(8)),
          decoration: BoxDecoration(color: color, shape: .circle),
        ),
        SizedBox(width: scale.space(12)),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: NinjaText.body.copyWith(color: colors.ink),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                    fontWeight: .w500,
                    color: colors.muted,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(fontWeight: .w600, color: color),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
