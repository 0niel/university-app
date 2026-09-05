part of 'mini_app_submit_page.dart';

class _SourceSection extends StatelessWidget {
  const _SourceSection({
    required this.sourceKind,
    required this.originController,
    required this.entryPathController,
    required this.screens,
    required this.onKindChanged,
    required this.onPreview,
    required this.onAddScreen,
    required this.onApplyTemplate,
    required this.onRemoveScreen,
  });

  final MiniAppSourceKind sourceKind;
  final TextEditingController originController;
  final TextEditingController entryPathController;
  final List<ScreenDraft> screens;
  final ValueChanged<MiniAppSourceKind> onKindChanged;
  final void Function(ScreenDraft screen) onPreview;
  final VoidCallback onAddScreen;
  final ValueChanged<MiniAppTemplate> onApplyTemplate;
  final void Function(ScreenDraft screen) onRemoveScreen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .start,
      children: [
        _SubmitSectionLabel(
          title: l10n.miniAppsSubmitSource,
          subtitle: l10n.miniAppsSubmitSourceSubtitle,
        ),
        NinjaSegmented<MiniAppSourceKind>(
          value: sourceKind,
          onChanged: onKindChanged,
          segments: [
            NinjaSegment(
              value: MiniAppSourceKind.hosted,
              label: l10n.miniAppsSourceHosted,
            ),
            NinjaSegment(
              value: MiniAppSourceKind.remote,
              label: l10n.miniAppsSourceRemote,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        if (sourceKind == .remote) ...[
          NinjaInput(
            controller: originController,
            keyboardType: .url,
            placeholder: 'https://my-app.example.com',
          ),
          const SizedBox(height: AppSpacing.md),
          NinjaInput(
            controller: entryPathController,
            placeholder: l10n.miniAppsSubmitEntryPathHint,
          ),
        ] else ...[
          _SubmitSectionLabel(
            title: l10n.miniAppsTplTitle,
            subtitle: l10n.miniAppsTplSubtitle,
          ),
          NinjaChipRow(
            padding: EdgeInsets.zero,
            children: [
              for (final template in miniAppTemplates)
                NinjaChip(
                  label: template.nameBuilder(context),
                  onTap: () => onApplyTemplate(template),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          for (var i = 0; i < screens.length; i++) ...[
            _ScreenEditor(
              key: ObjectKey(screens[i]),
              draft: screens[i],
              isEntry: i == 0,
              onPreview: () => onPreview(screens[i]),
              onRemove: i == 0 ? null : () => onRemoveScreen(screens[i]),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
          ],
          NinjaButton.outline(
            label: l10n.miniAppsSubmitAddScreen,
            expanded: true,
            icon: AppLineIconWidget(
              .plus,
              size: AppIconSize.sm,
              color: context.colors.muted,
            ),
            onPressed: onAddScreen,
          ),
        ],
      ],
    );
  }
}
