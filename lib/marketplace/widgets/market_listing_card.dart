import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/utils/utils.dart';

part 'listing_content.dart';
part 'listing_media.dart';

class MarketListingCard extends StatelessWidget {
  const MarketListingCard({
    required this.item,
    required this.now,
    required this.onOpen,
    required this.onToggleSold,
    required this.onDelete,
    super.key,
    this.isBusy = false,
  });

  final MarketListing item;
  final DateTime now;
  final VoidCallback onOpen;
  final VoidCallback onToggleSold;
  final VoidCallback onDelete;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final seller = item.sellerName.isEmpty
        ? l10n.marketSellerFallback
        : item.sellerName;
    final meta = [
      seller,
      if (item.createdAt case final createdAt?)
        relativeTime(l10n, createdAt, now: now),
    ].join(' · ');
    return Semantics(
      button: true,
      label: '${l10n.marketOpenDetails}: ${item.title}',
      child: Opacity(
        opacity: item.isSold ? 0.62 : 1,
        child: AppPressable(
          onTap: onOpen,
          onLongPress: item.isMine
              ? () => unawaited(_showOwnerActions(context))
              : null,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(NinjaRadius.card),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final stacked =
                      constraints.maxWidth < 340 ||
                      MediaQuery.textScalerOf(context).scale(1) > 1.35;
                  final media = _ListingMedia(
                    item: item,
                    isBusy: isBusy,
                    onOwnerActions: () => unawaited(_showOwnerActions(context)),
                  );
                  final content = _ListingContent(
                    item: item,
                    sellerMeta: meta,
                  );
                  if (stacked) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 126, child: media),
                        const SizedBox(height: 14),
                        content,
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 96, height: 112, child: media),
                      const SizedBox(width: 14),
                      Expanded(child: content),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showOwnerActions(BuildContext context) async {
    if (isBusy) return;
    unawaited(HapticFeedback.mediumImpact());
    await showAppSheet<void>(
      context,
      title: item.title,
      backgroundColor: context.ninja.canvas,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          NinjaButton.secondary(
            label: item.isSold
                ? context.l10n.marketMarkAvailable
                : context.l10n.marketMarkSold,
            icon: const AppLineIconWidget(AppLineIcon.check),
            size: NinjaButtonSize.large,
            expanded: true,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              onToggleSold();
            },
          ),
          const SizedBox(height: 10),
          NinjaButton.destructive(
            label: context.l10n.marketDelete,
            icon: const AppLineIconWidget(AppLineIcon.trash),
            size: NinjaButtonSize.large,
            expanded: true,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              onDelete();
            },
          ),
        ],
      ),
    );
  }
}
