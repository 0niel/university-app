import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promo_repository/promo_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/promo/cubit/cubit.dart';
import 'package:rtu_mirea_app/promo/promo_links.dart';
import 'package:rtu_mirea_app/promo/view/widgets/widgets.dart';
import 'package:share_launcher/share_launcher.dart';

class PromoDetailsPage extends StatefulWidget {
  const PromoDetailsPage({required this.slug, super.key});

  final String slug;

  @override
  State<PromoDetailsPage> createState() => _PromoDetailsPageState();
}

class _PromoDetailsPageState extends State<PromoDetailsPage> {
  var _requested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_requested) return;
    _requested = true;
    final cubit = context.read<PromoBannersCubit>();
    if (cubit.bySlug(widget.slug) == null) {
      unawaited(
        cubit.load(locale: Localizations.localeOf(context).languageCode),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<PromoBannersCubit>().state;
    final banner = context.read<PromoBannersCubit>().bySlug(widget.slug);
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: banner == null
          ? _Fallback(loading: state.isLoading || !state.loaded)
          : _PromoDetailsBody(banner: banner, title: l10n.promoDetailsTitle),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.loading});

  final bool loading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: EdgeInsets.only(bottom: ninjaBottomInset(context)),
      children: [
        AppInnerHeader(
          title: l10n.promoDetailsTitle,
          onBack: () => Navigator.of(context).maybePop(),
          backSemanticsLabel: l10n.back,
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: loading
              ? AppSkeletonGroup(
                  semanticsLabel: l10n.loadingContent,
                  child: const Column(
                    children: [
                      AppSkeleton(height: 220, radius: AppRadius.hero),
                      SizedBox(height: AppSpacing.sectionGap),
                      AppSkeletonRow(),
                      SizedBox(height: AppSpacing.sm),
                      AppSkeletonRow(),
                    ],
                  ),
                )
              : AppEmptyState(
                  title: l10n.promoNotFound,
                  lineIcon: AppLineIcon.hide,
                ),
        ),
      ],
    );
  }
}

class _PromoDetailsBody extends StatelessWidget {
  const _PromoDetailsBody({required this.banner, required this.title});

  final PromoBanner banner;
  final String title;

  void _track(BuildContext context, PromoEvent event) {
    context.read<PromoBannersCubit>().trackEvent(
      banner,
      event,
      placement: PromoPlacement.details,
    );
  }

  Future<void> _register(BuildContext context) {
    _track(context, PromoEvent.register);
    return openPromoLink(context, banner.ctaUrl);
  }

  Future<void> _contact(BuildContext context) async {
    final uri = promoTelegramUri(banner.contactTelegram);
    if (uri == null) return;
    _track(context, PromoEvent.contact);
    await openPromoLink(context, uri.toString());
  }

  Future<void> _share(BuildContext context) =>
      const ShareLauncher().share(text: '${banner.title}\n${banner.ctaUrl}');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final accent = promoAccentColor(banner.accentColor, colors.accent);
    final details = banner.details;
    final telegram = promoTelegramUri(banner.contactTelegram);
    final footnote = details.footnote;
    const bottomBarHeight =
        AppControlSize.buttonLarge + AppSpacing.lg * 2 + AppSpacing.sm;
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.paddingOf(context).bottom +
                bottomBarHeight +
                AppSpacing.lg,
          ),
          children: [
            AppInnerHeader(
              title: title,
              subtitle: banner.kicker,
              onBack: () => Navigator.of(context).maybePop(),
              backSemanticsLabel: l10n.back,
              actions: [
                AppHeaderAction(
                  icon: AppLineIcon.share,
                  semanticsLabel: l10n.share,
                  onTap: () => unawaited(_share(context)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.xl,
                AppSpacing.screen,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PromoHeroCard(
                    accent: accent,
                    emoji: banner.emoji,
                    badge: details.hero?.badge ?? banner.kicker,
                    title: details.hero?.title ?? banner.title,
                    subtitle: details.hero?.subtitle ?? banner.subtitle,
                    tags: details.hero?.tags ?? const [],
                  ),
                  for (final section in details.sections)
                    if (!section.isEmpty)
                      PromoSectionView(
                        section: section,
                        accent: accent,
                        onLink: (link) {
                          _track(context, PromoEvent.link);
                          unawaited(openPromoLink(context, link.url));
                        },
                      ),
                  if (telegram != null)
                    PromoContactCard(
                      title: details.contact?.title ?? l10n.promoContactTitle,
                      subtitle: details.contact?.subtitle,
                      handle: '@${banner.contactTelegram}',
                      actionLabel: l10n.promoWrite,
                      onTap: () => unawaited(_contact(context)),
                    ),
                  if (footnote != null && footnote.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xl),
                      child: Text(
                        footnote,
                        style: AppText.caption.copyWith(color: colors.muted),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: PromoBottomBar(
            accent: accent,
            registerLabel: banner.registerLabel,
            onRegister: () => unawaited(_register(context)),
            onContact: telegram == null
                ? null
                : () => unawaited(_contact(context)),
            contactSemanticsLabel: l10n.promoContactTelegram,
          ),
        ),
      ],
    );
  }
}
