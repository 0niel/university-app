part of '../schedule_page.dart';

class _WeekActivityChip extends StatelessWidget {
  const _WeekActivityChip({required this.activity});

  final UserActivity activity;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final foreground = colors.ink;
    final secondary = colors.mutedDark;
    return Padding(
      padding: const .only(bottom: 9),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          SizedBox(
            width: 78,
            child: Text(
              DateFormat('HH:mm').format(activity.startsAt),
              style: NinjaText.tabular(
                NinjaText.helper.copyWith(color: secondary),
              ),
            ),
          ),
          Container(
            width: 8,
            height: 8,
            margin: const .only(top: 3),
            decoration: BoxDecoration(
              color: _activityColor(colors, activity.type),
              shape: .circle,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              activity.title,
              maxLines: 2,
              overflow: .ellipsis,
              style: NinjaText.subtext.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}
