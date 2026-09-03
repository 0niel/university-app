import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:community_catalog_repository/community_catalog_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/communities/communities.dart';
import 'package:rtu_mirea_app/feed/widgets/page_action_bar.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunityDetailPage extends StatelessWidget {
  const CommunityDetailPage({
    required this.entry,
    required this.categoryTitle,
    super.key,
  });

  final CommunityCatalogEntry entry;
  final String categoryTitle;

  Future<void> _open(BuildContext context) async {
    var opened = false;
    try {
      final uri = entry.safeUri;
      if (uri != null) {
        opened = await launchUrl(uri, mode: .externalApplication);
      }
    } on Exception catch (_) {
      opened = false;
    }
    if (!opened && context.mounted) {
      showNinjaToast(context, message: context.l10n.error, showCheck: false);
    }
  }

  Future<void> _share(BuildContext context) async {
    try {
      final box = context.findRenderObject() as RenderBox?;
      await SharePlus.instance.share(
        ShareParams(
          text: entry.url,
          title: entry.title,
          sharePositionOrigin: box == null
              ? null
              : box.localToGlobal(Offset.zero) & box.size,
        ),
      );
    } on Exception catch (_) {
      if (context.mounted) {
        showNinjaToast(
          context,
          message: context.l10n.shareFailed,
          showCheck: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final saved = context.watch<JoinedCommunitiesCubit>();
    final selected = saved.isJoined(entry.id);
    final tone = communityCategoryTone(colors, categoryTitle);
    return Scaffold(
      backgroundColor: colors.canvas,
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.zero,
          AppSpacing.screen,
          ninjaBottomInset(context) + AppSpacing.lg,
        ),
        children: [
          PageActionBar(
            onBack: () => Navigator.of(context).maybePop(),
            actions: [
              AppIconButton(
                icon: const AppLineIconWidget(AppLineIcon.share),
                tooltip: l10n.share,
                tone: .surface,
                shape: .circle,
                onPressed: () => unawaited(_share(context)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.screen),
          SizedBox(
            height: 148,
            child: Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: colors.tintOf(tone),
                    borderRadius: BorderRadius.circular(AppRadius.hero),
                  ),
                ),
                Positioned(
                  left: 18,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: colors.canvas,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                    ),
                    child: CommunityTile(
                      name: entry.title,
                      logoUrl: entry.logoUrl,
                      size: 64,
                      radius: AppRadius.lg,
                      background: colors.surface,
                      foreground: tone,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.gap),
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked =
                  constraints.maxWidth < 320 ||
                  MediaQuery.textScalerOf(context).scale(1) > 1.4;
              final title = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    style: AppText.displaySmall.copyWith(
                      color: colors.ink,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xsm),
                  Text(
                    communityMeta(
                      l10n,
                      entry,
                      categoryTitle: categoryTitle,
                      joined: selected,
                    ),
                    style: AppText.sans(13, FontWeight.w500).copyWith(
                      color: colors.muted,
                    ),
                  ),
                ],
              );
              final button = CommunityJoinButton(
                label: selected ? l10n.communitiesSaved : l10n.communitiesSave,
                joined: selected,
                expanded: stacked,
                onTap: () => saved.toggle(entry.id),
              );
              return stacked
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        title,
                        const SizedBox(height: AppSpacing.md),
                        button,
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: title),
                        const SizedBox(width: AppSpacing.md),
                        button,
                      ],
                    );
            },
          ),
          if (entry.description.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sectionGap),
            Text(
              entry.description,
              style: AppText.sans(
                14.5,
                FontWeight.w400,
                height: 1.5,
              ).copyWith(color: colors.muted),
            ),
          ],
          const SizedBox(height: AppSpacing.fieldGap),
          _CommunityStats(
            entries: [
              ('${entry.membersCount ?? '—'}', l10n.communityStatMembers),
              (communityPlatformLabel(l10n, entry), l10n.communityStatPlatform),
              (
                categoryTitle.isEmpty ? '—' : categoryTitle,
                l10n.communityStatCategory,
              ),
            ],
          ),
          AppSectionTitle(
            title: l10n.communityFeed,
            action: l10n.communityWrite,
            onActionTap: () => unawaited(_open(context)),
          ),
          NinjaEmptyState(
            title: l10n.communityFeedEmpty,
            message: l10n.communityFeedEmptySub,
            actionLabel: l10n.communityOpenChat,
            onAction: () => unawaited(_open(context)),
          ),
        ],
      ),
    );
  }
}

class _CommunityStats extends StatelessWidget {
  const _CommunityStats({required this.entries});

  final List<(String, String)> entries;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked =
            constraints.maxWidth < 300 ||
            MediaQuery.textScalerOf(context).scale(1) > 1.4;
        final cards = [
          for (final (value, label) in entries)
            Container(
              padding: const EdgeInsets.all(AppSpacing.sectionGap),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(20, FontWeight.w800).copyWith(
                      color: colors.ink,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    label,
                    style: AppText.sans(12, FontWeight.w500).copyWith(
                      color: colors.muted,
                    ),
                  ),
                ],
              ),
            ),
        ];
        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, card) in cards.indexed) ...[
                if (index > 0) const SizedBox(height: AppSpacing.sm),
                card,
              ],
            ],
          );
        }
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, card) in cards.indexed) ...[
                if (index > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(child: card),
              ],
            ],
          ),
        );
      },
    );
  }
}
