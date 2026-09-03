import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/cubit/market_contact_prefs_cubit.dart';
import 'package:rtu_mirea_app/marketplace/cubit/marketplace_cubit.dart';
import 'package:rtu_mirea_app/marketplace/widgets/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MarketplaceView extends StatelessWidget {
  const MarketplaceView({
    super.key,
    this.favoriteIds = const {},
    this.onToggleFavorite,
  });

  final Set<String> favoriteIds;
  final ValueChanged<String>? onToggleFavorite;

  Future<void> _sell(BuildContext context, {MarketListing? editing}) async {
    final marketplaceCubit = context.read<MarketplaceCubit>();
    final contactCubit = context.read<MarketContactPrefsCubit>();
    await showAppSheet<void>(
      context,
      title: editing == null
          ? context.l10n.marketSellTitle
          : context.l10n.marketEditTitle,
      subtitle: context.l10n.marketSellSubtitle,
      backgroundColor: context.colors.canvas,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: marketplaceCubit),
          BlocProvider.value(value: contactCubit),
        ],
        child: MarketSellSheet(editing: editing),
      ),
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
        onShare: () => unawaited(_share(context, item)),
        onEdit: item.isMine
            ? () {
                Navigator.of(context, rootNavigator: true).pop();
                unawaited(_sell(context, editing: item));
              }
            : null,
        onToggleSold: item.isMine
            ? () {
                Navigator.of(context, rootNavigator: true).pop();
                unawaited(_toggle(context, item));
              }
            : null,
        onArchive: item.isMine
            ? () {
                Navigator.of(context, rootNavigator: true).pop();
                unawaited(_archive(context, item));
              }
            : null,
        onDelete: item.isMine
            ? () {
                Navigator.of(context, rootNavigator: true).pop();
                unawaited(_delete(context, item));
              }
            : null,
      ),
    );
  }

  Future<void> _share(BuildContext context, MarketListing item) async {
    await SharePlus.instance.share(
      ShareParams(text: context.l10n.marketShareText(item.title)),
    );
  }

  Future<void> _contact(BuildContext context, MarketListing item) async {
    final rawHandle = item.showContact ? (item.telegramHandle ?? '') : '';
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
    final confirmed = await showAppConfirmDialog(
      context,
      title: context.l10n.marketDeleteConfirmTitle,
      message: context.l10n.marketDeleteConfirmBody,
      confirmLabel: context.l10n.marketDelete,
      cancelLabel: context.l10n.collabNotesCancel,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final deleted = await context.read<MarketplaceCubit>().delete(item);
    if (!context.mounted) return;
    if (deleted) {
      ToastManager.showSuccess(
        context,
        message: context.l10n.marketDeleteSuccess,
      );
    } else {
      _showError(context, context.l10n.marketMutationError);
    }
  }

  Future<void> _archive(BuildContext context, MarketListing item) async {
    final confirmed = await showAppConfirmDialog(
      context,
      title: context.l10n.marketArchiveConfirmTitle,
      message: context.l10n.marketArchiveConfirmBody,
      confirmLabel: context.l10n.marketArchive,
      cancelLabel: context.l10n.collabNotesCancel,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final archived = await context.read<MarketplaceCubit>().archive(item);
    if (!context.mounted) return;
    if (archived) {
      ToastManager.showSuccess(
        context,
        message: context.l10n.marketArchiveSuccess,
      );
    } else {
      _showError(context, context.l10n.marketArchiveError);
    }
  }

  void _showError(BuildContext context, String message) {
    ToastManager.showError(context, message: message);
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
          onSell: state.isSaving ? null : () => unawaited(_sell(context)),
          onOpen: (item) => unawaited(_details(context, item)),
          onContact: (item) => unawaited(_contact(context, item)),
          favoriteIds: favoriteIds,
          onToggleFavorite: onToggleFavorite,
        ),
      ),
    );
  }
}
