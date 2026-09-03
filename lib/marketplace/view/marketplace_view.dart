import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/cubit/marketplace_cubit.dart';
import 'package:rtu_mirea_app/marketplace/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class MarketplaceView extends StatelessWidget {
  const MarketplaceView({
    super.key,
    this.favoriteIds = const {},
    this.onToggleFavorite,
  });

  final Set<String> favoriteIds;
  final ValueChanged<String>? onToggleFavorite;

  Future<void> _sell(BuildContext context) async {
    final cubit = context.read<MarketplaceCubit>();
    await showAppSheet<void>(
      context,
      title: context.l10n.marketSellTitle,
      subtitle: context.l10n.marketSellSubtitle,
      backgroundColor: context.colors.canvas,
      child: BlocProvider.value(value: cubit, child: const MarketSellSheet()),
    );
  }

  Future<void> _details(BuildContext context, MarketListing item) async {
    await showAppSheet<void>(
      context,
      title: context.l10n.marketDetailsTitle,
      subtitle: item.title,
      backgroundColor: context.colors.canvas,
      child: MarketListingDetailsSheet(
        item: item,
        onContact: () => unawaited(_contact(context, item)),
      ),
    );
  }

  Future<void> _contact(BuildContext context, MarketListing item) async {
    final rawHandle = item.showContact ? (item.sellerHandle ?? '') : '';
    final handle = rawHandle.trim().replaceFirst(RegExp('^@'), '');
    if (!RegExp(r'^[A-Za-z0-9_]{5,32}$').hasMatch(handle)) {
      _showError(context, context.l10n.marketContactUnavailable);
      return;
    }
    var opened = false;
    try {
      opened = await launchUrl(
        Uri.https('t.me', '/$handle'),
        mode: .externalApplication,
      );
    } on Exception catch (_) {
      opened = false;
    }
    if (!opened && context.mounted) {
      _showError(context, context.l10n.marketTelegramOpenError);
    }
  }

  Future<void> _toggle(BuildContext context, MarketListing item) async {
    final changed = await context.read<MarketplaceCubit>().toggleSold(item);
    if (!changed && context.mounted) {
      _showError(context, context.l10n.marketMutationError);
    }
  }

  Future<void> _delete(BuildContext context, MarketListing item) async {
    final confirmed = await showNinjaConfirmDialog(
      context,
      title: context.l10n.marketDeleteConfirmTitle,
      message: context.l10n.marketDeleteConfirmBody,
      confirmLabel: context.l10n.marketDelete,
      cancelLabel: context.l10n.collabNotesCancel,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final deleted = await context.read<MarketplaceCubit>().delete(item);
    if (!deleted && context.mounted) {
      _showError(context, context.l10n.marketMutationError);
    }
  }

  void _showError(BuildContext context, String message) {
    NinjaToastHost.maybeOf(
      context,
    )?.show(NinjaToastData(message: message, showCheck: false));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocConsumer<MarketplaceCubit, MarketplaceState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == .failure &&
          current.items.isNotEmpty,
      listener: (context, _) =>
          _showError(context, context.l10n.marketRefreshError),
      builder: (context, state) => Scaffold(
        backgroundColor: colors.canvas,
        body: MarketplaceBody(
          onSell: state.isCreating ? null : () => unawaited(_sell(context)),
          onOpen: (item) => unawaited(_details(context, item)),
          onToggleSold: (item) => unawaited(_toggle(context, item)),
          onDelete: (item) => unawaited(_delete(context, item)),
          onContact: (item) => unawaited(_contact(context, item)),
          favoriteIds: favoriteIds,
          onToggleFavorite: onToggleFavorite,
        ),
      ),
    );
  }
}
