part of 'add_schedule_page.dart';

class _CreateScheduleRow extends StatelessWidget {
  const _CreateScheduleRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NinjaMetrics.screenPadding,
      ),
      child: AppPressable(
        onTap: onTap,
        semanticsLabel: l10n.addScheduleCreateTitle,
        child: Container(
          constraints: const BoxConstraints(minHeight: 72),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(NinjaRadius.card),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: '${l10n.addScheduleNotFound} '),
                          TextSpan(
                            text: l10n.addScheduleCreateTitle,
                            style: NinjaText.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colors.brandInk,
                            ),
                          ),
                        ],
                        style: NinjaText.body.copyWith(color: colors.mutedDark),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.addScheduleCreateSubtitle,
                      style: NinjaText.subtext.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              AppLineIconWidget(
                AppLineIcon.chevronR,
                size: 16,
                color: colors.chevron,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
