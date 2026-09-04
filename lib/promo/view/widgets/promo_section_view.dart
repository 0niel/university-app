import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:promo_repository/promo_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/promo/view/widgets/promo_faq_tile.dart';

class PromoSectionView extends StatelessWidget {
  const PromoSectionView({
    required this.section,
    required this.accent,
    required this.onLink,
    super.key,
  });

  final PromoSection section;
  final Color accent;
  final ValueChanged<PromoLink> onLink;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = switch (section) {
      PromoFactsSection(:final title) =>
        title.isEmpty ? l10n.promoSectionFacts : title,
      PromoStepsSection(:final title) =>
        title.isEmpty ? l10n.promoSectionSteps : title,
      PromoChecklistSection(:final title) =>
        title.isEmpty ? l10n.promoSectionChecklist : title,
      PromoFaqSection(:final title) =>
        title.isEmpty ? l10n.promoSectionFaq : title,
      PromoTextSection(:final title) => title,
      PromoLinksSection(:final title) =>
        title.isEmpty ? l10n.promoSectionLinks : title,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title.isNotEmpty) AppSectionTitle(title: title),
        switch (section) {
          PromoFactsSection(:final items) => _Facts(items: items),
          PromoStepsSection(:final items) => _Steps(
            items: items,
            accent: accent,
          ),
          PromoChecklistSection(:final items) => _Checklist(
            items: items,
            accent: accent,
          ),
          PromoFaqSection(:final items) => AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final (index, item) in items.indexed)
                  PromoFaqTile(item: item, isFirst: index == 0),
              ],
            ),
          ),
          PromoTextSection(:final body) => AppCard(
            child: Text(
              body,
              style: AppText.body.copyWith(color: context.colors.ink),
            ),
          ),
          PromoLinksSection(:final items) => AppListGroup(
            children: [
              for (final (index, link) in items.indexed)
                AppListRow(
                  isFirst: index == 0,
                  leading: AppIconTile(
                    icon: AppLineIcon.external,
                    foreground: accent,
                  ),
                  title: link.label,
                  subtitle: Uri.tryParse(link.url)?.host,
                  onTap: () => onLink(link),
                ),
            ],
          ),
        },
      ],
    );
  }
}

class _Facts extends StatelessWidget {
  const _Facts({required this.items});

  final List<PromoFact> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        children: [
          for (final (index, fact) in items.indexed)
            Padding(
              padding: EdgeInsets.only(
                top: index == 0 ? AppSpacing.sm : AppSpacing.md,
                bottom: AppSpacing.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppIconTile(
                    size: AppControlSize.iconTileMedium,
                    background: colors.surface2,
                    child: Text(
                      fact.emoji ?? '•',
                      style: AppText.sans(19, FontWeight.w400, height: 1),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fact.label,
                          style: AppText.bodyStrong.copyWith(color: colors.ink),
                        ),
                        if (fact.value.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            fact.value,
                            style: AppText.subtext.copyWith(
                              color: colors.muted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Steps extends StatelessWidget {
  const _Steps({required this.items, required this.accent});

  final List<PromoStep> items;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      child: Column(
        children: [
          for (final (index, step) in items.indexed)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == items.length - 1 ? 0 : AppSpacing.lg,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: AppControlSize.iconTileCompact,
                    height: AppControlSize.iconTileCompact,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: AppText.sans(
                        14,
                        FontWeight.w700,
                        height: 1,
                        tabular: true,
                      ).copyWith(color: colors.white),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            step.title,
                            style: AppText.bodyStrong.copyWith(
                              color: colors.ink,
                            ),
                          ),
                        ),
                        if (step.text.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            step.text,
                            style: AppText.subtext.copyWith(
                              color: colors.muted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Checklist extends StatelessWidget {
  const _Checklist({required this.items, required this.accent});

  final List<String> items;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      child: Column(
        children: [
          for (final (index, item) in items.indexed)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == items.length - 1 ? 0 : AppSpacing.md,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xxs),
                    child: AppLineIconWidget(
                      AppLineIcon.check,
                      size: AppIconSize.compact,
                      color: accent,
                      strokeWidth: 2.5,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      item,
                      style: AppText.body.copyWith(color: colors.ink),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
