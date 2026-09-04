import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promo_repository/promo_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/promo/cubit/cubit.dart';
import 'package:rtu_mirea_app/promo/promo_links.dart';
import 'package:rtu_mirea_app/promo/promo_visibility.dart';
import 'package:rtu_mirea_app/promo/view/promo_hide_sheet.dart';

class PromoBannerSlot extends StatelessWidget {
  const PromoBannerSlot({
    required this.placement,
    super.key,
    this.homeSlot,
    this.padding = EdgeInsets.zero,
    this.now,
    this.compact = false,
  });

  final PromoPlacement placement;
  final PromoHomeSlot? homeSlot;
  final EdgeInsetsGeometry padding;
  final DateTime? now;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final preferences = context.watch<UiPreferencesCubit?>()?.state;
    final banners = context.watch<PromoBannersCubit?>()?.state.banners;
    final dismissals = context.watch<PromoDismissalsCubit?>()?.state;
    final banner =
        preferences != null &&
            preferences.showPromoBanners &&
            banners != null &&
            dismissals != null
        ? visiblePromoBanners(
            banners: banners,
            dismissals: dismissals,
            placement: placement,
            homeSlot: homeSlot,
            now: now ?? DateTime.now(),
          ).firstOrNull
        : null;
    return AnimatedSize(
      duration: NinjaMotion.of(context),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: banner == null
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: padding,
              child: _PromoBannerView(
                key: ValueKey(banner.dismissKey),
                banner: banner,
                placement: placement,
                compact: compact,
              ),
            ),
    );
  }
}

class _PromoBannerView extends StatefulWidget {
  const _PromoBannerView({
    required this.banner,
    required this.placement,
    required this.compact,
    super.key,
  });

  final PromoBanner banner;
  final PromoPlacement placement;
  final bool compact;

  @override
  State<_PromoBannerView> createState() => _PromoBannerViewState();
}

class _PromoBannerViewState extends State<_PromoBannerView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PromoBannersCubit>().trackImpression(
        widget.banner,
        widget.placement,
      );
    });
  }

  void _open() {
    context.read<PromoBannersCubit>().trackEvent(
      widget.banner,
      PromoEvent.open,
      placement: widget.placement,
    );
    unawaited(PromoDetailsRoute(slug: widget.banner.slug).push<void>(context));
  }

  Future<void> _dismiss() async {
    final choice = await showPromoHideSheet(context, widget.banner);
    if (!mounted || choice == null) return;
    final banners = context.read<PromoBannersCubit>();
    final dismissals = context.read<PromoDismissalsCubit>();
    switch (choice) {
      case PromoHideChoice.snooze:
        dismissals.snooze(widget.banner);
        banners.trackEvent(
          widget.banner,
          PromoEvent.snooze,
          placement: widget.placement,
        );
      case PromoHideChoice.forever:
        dismissals.hide(widget.banner);
        banners.trackEvent(
          widget.banner,
          PromoEvent.hide,
          placement: widget.placement,
        );
        ToastManager.showInfo(context, message: context.l10n.promoHiddenToast);
    }
  }

  @override
  Widget build(BuildContext context) {
    final banner = widget.banner;
    return AppPromoCard(
      title: banner.title,
      kicker: widget.compact ? null : banner.kicker,
      subtitle: widget.compact ? null : banner.subtitle,
      emoji: banner.emoji,
      actionLabel: banner.ctaLabel,
      accent: promoAccentColor(banner.accentColor, context.colors.accent),
      solid: banner.style == PromoStyle.solid,
      compact: widget.compact,
      onTap: _open,
      onClose: banner.dismissible ? _dismiss : null,
      closeSemanticsLabel: context.l10n.promoHideSheetTitle,
    );
  }
}
