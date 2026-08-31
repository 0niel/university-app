part of '../deadline_row.dart';

class _DeadlineVisual extends StatelessWidget {
  const _DeadlineVisual({
    required this.done,
    required this.urgent,
    required this.color,
  });

  final bool done;
  final bool urgent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final tint = done
        ? colors.successTint
        : urgent
        ? colors.dangerTint
        : colors.brandTint;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(NinjaRadius.control),
      ),
      child: SizedBox.square(
        dimension: 44,
        child: Center(
          child: AppLineIconWidget(
            done
                ? AppLineIcon.check
                : urgent
                ? AppLineIcon.bell
                : AppLineIcon.calendar,
            size: 20,
            color: color,
          ),
        ),
      ),
    );
  }
}
