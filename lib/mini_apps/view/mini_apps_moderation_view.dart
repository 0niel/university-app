part of 'mini_apps_moderation_page.dart';

class MiniAppsModerationView extends StatelessWidget {
  const MiniAppsModerationView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final state = context.watch<MiniAppsModerationCubit>().state;
    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: NinjaAppBar.inner(
        title: l10n.miniAppsModerationTitle,
        onBack: () => Navigator.of(context).maybePop(),
        backSemanticLabel: l10n.back,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Text(
              l10n.miniAppsModerationSubtitle,
              style: NinjaText.body.copyWith(color: colors.muted),
            ),
          ),
          Expanded(child: _ModerationBody(state: state)),
        ],
      ),
    );
  }
}
