part of 'mini_apps_catalog.dart';

class _CatalogFeedback extends StatelessWidget {
  const _CatalogFeedback({required this.state, required this.onRetry});

  final MiniAppsCatalogState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final hasContent = state.hasVisibleContent;
    final colors = context.colors;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final loading = hasContent && state.status == MiniAppsCatalogStatus.loading;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppExpandingSection(
          expanded: loading,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 6),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: TickerMode(
                enabled: loading && !reduceMotion,
                child: LinearProgressIndicator(
                  minHeight: 2,
                  color: colors.accent,
                  backgroundColor: colors.surface,
                  semanticsLabel: context.l10n.loadingContent,
                ),
              ),
            ),
          ),
        ),
        AppExpandingSection(
          expanded: hasContent && state.status == MiniAppsCatalogStatus.failure,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: AppGlassSurface(
              tone: AppGlassTone.accent,
              tint: colors.warn,
              borderRadius: AppRadius.field,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final message = Row(
                    children: [
                      AppLineIconWidget(
                        AppLineIcon.wifiOff,
                        color: colors.warn,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          context.l10n.loadingError,
                          style: AppText.caption.copyWith(color: colors.ink),
                        ),
                      ),
                    ],
                  );
                  final retry = AppButton.text(
                    label: context.l10n.retry,
                    onPressed: onRetry,
                  );
                  final largeText =
                      MediaQuery.textScalerOf(context).scale(14) > 20;
                  if (constraints.maxWidth < 300 || largeText) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSpacing.sm),
                        message,
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: retry,
                        ),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: message),
                      retry,
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
