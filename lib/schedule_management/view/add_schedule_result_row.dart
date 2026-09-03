part of 'add_schedule_page.dart';

class _AddScheduleResultRow extends StatefulWidget {
  const _AddScheduleResultRow({
    required this.result,
    required this.added,
    super.key,
  });

  final _AddScheduleResult result;
  final bool added;

  @override
  State<_AddScheduleResultRow> createState() => _AddScheduleResultRowState();
}

class _AddScheduleResultRowState extends State<_AddScheduleResultRow> {
  bool _pending = false;

  void _add() {
    if (_pending || widget.added) return;
    setState(() => _pending = true);
    widget.result.onSubscribe(context.read());
  }

  void _onScheduleChanged(BuildContext context, ScheduleState state) {
    if (!_pending) return;
    final added = widget.result.isAdded(state);
    if (!added && state.status != ScheduleStatus.failure) return;
    setState(() => _pending = false);
    showNinjaToast(
      context,
      showCheck: added,
      message: added
          ? '${widget.result.name} · ${context.l10n.addScheduleAdded}'
          : context.l10n.loadingError,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final result = widget.result;
    final reducedMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final duration = reducedMotion
        ? Duration.zero
        : const Duration(milliseconds: 220);
    return BlocConsumer<ScheduleBloc, ScheduleState>(
      listener: _onScheduleChanged,
      builder: (context, state) {
        final added = widget.added || result.isAdded(state);
        final busy = _pending || state.status == ScheduleStatus.loading;
        final button = AnimatedSwitcher(
          duration: duration,
          switchInCurve: Curves.easeOutCubic,
          child: AppButton(
            key: ValueKey(added),
            label: added ? l10n.addScheduleAdded : l10n.addScheduleAddAction,
            icon: AppLineIconWidget(
              added ? AppLineIcon.check : AppLineIcon.plus,
            ),
            variant: added ? AppButtonVariant.tonal : AppButtonVariant.primary,
            backgroundColor: added ? colors.tint : null,
            foregroundColor: added ? colors.accent : null,
            size: AppButtonSize.small,
            expanded: true,
            loading: _pending,
            onPressed: added || busy ? null : _add,
          ),
        );
        final title = Row(
          children: [
            ScheduleEntityAvatar(target: result.target, name: result.name),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    result.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.cell.copyWith(color: colors.ink),
                  ),
                  if (result.subtitle case final subtitle?
                      when subtitle.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.caption.copyWith(color: colors.muted),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            0,
            AppSpacing.screen,
            AppSpacing.gap,
          ),
          child: AnimatedContainer(
            duration: duration,
            constraints: const BoxConstraints(minHeight: 76),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 300 ||
                    MediaQuery.textScalerOf(context).scale(1) >= 1.5) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      title,
                      const SizedBox(height: AppSpacing.md),
                      button,
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(child: title),
                    const SizedBox(width: AppSpacing.md),
                    SizedBox(width: 128, child: button),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
