import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/lost_and_found/cubit/lost_found_cubit.dart';
import 'package:rtu_mirea_app/lost_and_found/utils/utils.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_gallery.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_item_header.dart';

part 'info_surface.dart';

class LostFoundItemSheet extends StatelessWidget {
  const LostFoundItemSheet({
    required this.item,
    this.contactLauncher = const UrlLostFoundContactLauncher(),
    super.key,
  });

  final LostFoundItem item;
  final LostFoundContactLauncher contactLauncher;

  Future<void> _contact(
    BuildContext context,
    Future<bool> Function() action,
  ) async {
    if (await action() || !context.mounted) return;
    NinjaToastHost.maybeOf(context)?.show(
      NinjaToastData(
        message: context.l10n.lostFoundContactOpenError,
        showCheck: false,
      ),
    );
  }

  Future<void> _mutate(
    BuildContext context,
    Future<bool> Function() action,
  ) async {
    final succeeded = await action();
    if (!context.mounted) return;
    if (succeeded) {
      Navigator.of(context).pop();
    } else {
      NinjaToastHost.maybeOf(context)?.show(
        NinjaToastData(
          message: context.l10n.lostFoundActionError,
          showCheck: false,
        ),
      );
    }
  }

  Future<void> _delete(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showNinjaConfirmDialog(
      context,
      title: l10n.lostFoundDeleteConfirmTitle,
      message: l10n.lostFoundDeleteConfirmBody,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final cubit = context.read<LostFoundCubit>();
    await _mutate(context, () => cubit.deleteItem(item));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final telegram = item.telegramContactInfo;
    final phone = item.phoneNumberContactInfo;
    final description = item.description;
    final cubit = context.read<LostFoundCubit>();
    final busy = context.select<LostFoundCubit, bool>(
      (value) =>
          value.state.pendingStatusIds.contains(item.id) ||
          value.state.pendingDeleteIds.contains(item.id),
    );
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LostFoundItemHeader(item: item),
          if (item.images.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xlg),
            LostFoundGallery(images: item.images),
          ],
          if (description case final value? when value.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xlg),
            _InfoSurface(
              child: Text(
                value,
                style: NinjaText.body.copyWith(
                  color: colors.ink,
                  height: 1.5,
                ),
              ),
            ),
          ],
          if (item.location.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _InfoSurface(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLineIconWidget(
                    AppLineIcon.pin,
                    size: AppIconSize.md,
                    color: colors.brand,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      item.location,
                      style: NinjaText.body.copyWith(
                        color: colors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xlg),
          if (item.isMine) ...[
            NinjaButton.primary(
              label: busy
                  ? l10n.lostFoundBusy
                  : item.status == .found
                  ? l10n.lostFoundFoundOwner
                  : l10n.lostFoundFoundItem,
              icon: const AppLineIconWidget(AppLineIcon.swap),
              size: NinjaButtonSize.large,
              expanded: true,
              loading: busy,
              onPressed: busy
                  ? null
                  : () => _mutate(context, () => cubit.toggleItemStatus(item)),
            ),
            const SizedBox(height: AppSpacing.gap),
            NinjaButton.destructiveOutline(
              label: l10n.lostFoundDelete,
              icon: const AppLineIconWidget(AppLineIcon.trash),
              size: NinjaButtonSize.large,
              expanded: true,
              onPressed: busy ? null : () => _delete(context),
            ),
          ] else ...[
            if (telegram case final String value when value.isNotEmpty)
              NinjaButton.primary(
                label: l10n.friendsWriteTelegram,
                icon: const AppLineIconWidget(AppLineIcon.send),
                size: NinjaButtonSize.large,
                expanded: true,
                onPressed: () => _contact(
                  context,
                  () => contactLauncher.openTelegram(value),
                ),
              ),
            if (phone case final String value when value.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.gap),
              NinjaButton.secondary(
                label: l10n.lostFoundCall(value),
                icon: const AppLineIconWidget(AppLineIcon.phone),
                size: NinjaButtonSize.large,
                expanded: true,
                onPressed: () =>
                    _contact(context, () => contactLauncher(value)),
              ),
            ],
            if ((telegram == null || telegram.isEmpty) &&
                (phone == null || phone.isEmpty))
              _InfoSurface(
                child: Row(
                  children: [
                    AppLineIconWidget(
                      AppLineIcon.lock,
                      color: colors.muted,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        l10n.lostFoundContactUnavailable,
                        style: NinjaText.body.copyWith(color: colors.muted),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
