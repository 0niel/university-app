part of 'mini_apps_moderation_page.dart';

class MiniAppsModerationView extends StatelessWidget {
  const MiniAppsModerationView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final state = context.watch<MiniAppsModerationCubit>().state;
    return MiniAppScaffold(
      title: l10n.miniAppsModerationTitle,
      scrollingHeader: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            0,
            AppSpacing.screen,
            AppSpacing.lg,
          ),
          child: Text(
            l10n.miniAppsModerationSubtitle,
            style: AppText.body.copyWith(color: colors.muted),
          ),
        ),
      ],
      body: _ModerationBody(state: state),
    );
  }
}
