part of 'mini_apps_catalog.dart';

class _MiniAppsSearchField extends StatelessWidget {
  const _MiniAppsSearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const .fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        AppSpacing.sm,
      ),
      child: AppSearchField(
        controller: controller,
        focusNode: focusNode,
        hintText: l10n.miniAppsSearchHint,
        isOnCanvas: true,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
