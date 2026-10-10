import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class TeacherMetrics extends StatelessWidget {
  const TeacherMetrics({required this.metrics, super.key});

  final List<(String, String)> metrics;

  @override
  Widget build(BuildContext context) => AppCard(
    key: const ValueKey('teacher-dashboard-workload'),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >= 248 &&
            MediaQuery.textScalerOf(context).scale(1) <= 1.4;
        final width = wide
            ? (constraints.maxWidth - AppSpacing.lg) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: [
            for (final metric in metrics)
              SizedBox(
                width: width,
                child: Semantics(
                  container: true,
                  label: '${metric.$1}: ${metric.$2}',
                  child: ExcludeSemantics(
                    child: wide
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _value(context, metric.$2),
                              const SizedBox(height: AppSpacing.xs),
                              _label(context, metric.$1),
                            ],
                          )
                        : Wrap(
                            spacing: AppSpacing.md,
                            runSpacing: AppSpacing.xs,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              _value(context, metric.$2),
                              _label(context, metric.$1),
                            ],
                          ),
                  ),
                ),
              ),
          ],
        );
      },
    ),
  );

  Widget _value(BuildContext context, String value) => Text(
    value,
    style: AppText.metric.copyWith(color: context.colors.ink),
  );

  Widget _label(BuildContext context, String label) => Text(
    label,
    style: AppText.subtext.copyWith(color: context.colors.muted),
  );
}
