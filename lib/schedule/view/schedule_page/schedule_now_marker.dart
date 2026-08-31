part of '../schedule_page.dart';

class _ScheduleNowMarker extends StatelessWidget {
  const _ScheduleNowMarker({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Semantics(
      container: true,
      liveRegion: true,
      label: label,
      child: ExcludeSemantics(
        child: Padding(
          padding: const .fromLTRB(
            NinjaMetrics.screenPadding,
            3,
            NinjaMetrics.screenPadding,
            11,
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colors.brand,
                  shape: .circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: NinjaText.buttonSmall.copyWith(
                    color: colors.mutedDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
