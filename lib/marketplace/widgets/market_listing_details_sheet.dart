import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/utils/utils.dart';

class MarketListingDetailsSheet extends StatelessWidget {
  const MarketListingDetailsSheet({
    required this.item,
    required this.onContact,
    super.key,
  });

  final MarketListing item;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final seller = item.sellerName.isEmpty
        ? l10n.marketSellerFallback
        : item.sellerName;
    final canContact =
        item.showContact && (item.sellerHandle?.isNotEmpty ?? false);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(NinjaRadius.card),
            child: SizedBox(
              height: 150,
              child: ColoredBox(
                color: colors.surfaceAlt,
                child: Center(
                  child: Text(item.emoji, style: const TextStyle(fontSize: 52)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  marketplacePrice(
                    l10n,
                    item.price,
                    UniversityConfig.current.marketplaceCurrencyCode,
                  ),
                  style: NinjaText.tabular(
                    NinjaText.title.copyWith(
                      color: item.isFree ? colors.brandInk : colors.ink,
                    ),
                  ),
                ),
              ),
              if (item.isSold)
                NinjaBadge(l10n.marketSold, tone: NinjaBadgeTone.ink),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.description.isEmpty
                ? l10n.marketDescriptionEmpty
                : item.description,
            style: NinjaText.body.copyWith(
              height: 1.5,
              color: item.description.isEmpty ? colors.muted : colors.mutedDark,
            ),
          ),
          const SizedBox(height: 16),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(NinjaRadius.card),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  NinjaAvatar(initials: ninjaInitials(seller), size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      seller,
                      style: NinjaText.headline.copyWith(color: colors.ink),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!item.isMine) ...[
            const SizedBox(height: 18),
            NinjaButton.primary(
              label: canContact
                  ? l10n.marketContactSeller
                  : l10n.marketContactUnavailable,
              icon: const AppLineIconWidget(AppLineIcon.send),
              size: NinjaButtonSize.large,
              expanded: true,
              onPressed: canContact ? onContact : null,
            ),
          ],
        ],
      ),
    );
  }
}
