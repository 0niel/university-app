import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/cowork/cubit/cowork_cubit.dart';
import 'package:rtu_mirea_app/cowork/utils/cowork_format.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CoworkDetailsCard extends StatelessWidget {
  const CoworkDetailsCard({required this.state, super.key, this.onExtend});

  final CoworkState state;
  final VoidCallback? onExtend;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final booking = state.activeBooking;
    final from = booking?.from ?? state.current;
    final until = booking?.until ?? state.bookingUntil(state.current);
    final extendedUntil = state.extendedUntil;
    final friends = state.friendsHere;
    return AppCard(
      radius: AppRadius.row,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DetailRow(
            label: l10n.coworkTimeLabel,
            child: Text(
              '${formatClock(from)} → ${formatClock(until)}',
              style: AppText.bodyStrong.copyWith(color: colors.muted),
            ),
          ),
          const SizedBox(height: 10),
          _DetailRow(
            label: l10n.coworkExtendLabel,
            child: booking == null
                ? Text(
                    l10n.coworkExtendAvailable,
                    style: AppText.bodyStrong.copyWith(color: colors.lecture),
                  )
                : extendedUntil == null
                ? Text(
                    l10n.coworkExtendMax,
                    style: AppText.bodyStrong.copyWith(color: colors.muted),
                  )
                : AppPressable(
                    onTap: state.saving ? null : onExtend,
                    semanticsButton: true,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 44),
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        widthFactor: 1,
                        child: Text(
                          l10n.coworkExtendAction(formatClock(extendedUntil)),
                          style: AppText.bodyStrong.copyWith(
                            color: colors.accent,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 10),
          _DetailRow(
            label: l10n.coworkFriendsLabel,
            child: friends.isEmpty
                ? Text(
                    l10n.noData,
                    style: AppText.bodyStrong.copyWith(color: colors.muted),
                  )
                : AppAvatarStack(names: friends, size: 24, maxVisible: 3),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (MediaQuery.textScalerOf(context).scale(14) > 19) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.bodyStrong.copyWith(color: colors.ink)),
          const SizedBox(height: 4),
          child,
        ],
      );
    }
    return Row(
      children: [
        Text(label, style: AppText.bodyStrong.copyWith(color: colors.ink)),
        const SizedBox(width: 12),
        Expanded(
          child: Align(alignment: Alignment.centerRight, child: child),
        ),
      ],
    );
  }
}
