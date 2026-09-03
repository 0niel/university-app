import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/cowork/cubit/cowork_cubit.dart';
import 'package:rtu_mirea_app/cowork/utils/cowork_format.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CoworkBookButton extends StatelessWidget {
  const CoworkBookButton({
    required this.state,
    required this.onBook,
    required this.onCancel,
    super.key,
  });

  final CoworkState state;
  final VoidCallback onBook;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final booking = state.activeBooking;
    if (booking != null) {
      return AppButton.secondary(
        label: l10n.coworkCancelBooking,
        size: AppButtonSize.large,
        expanded: true,
        loading: state.saving,
        onPressed: state.saving ? null : onCancel,
      );
    }
    final seatId = state.selectedSeatId;
    if (!state.canPlan) {
      return AppButton.primary(
        label: l10n.coworkClosed,
        expanded: true,
        size: AppButtonSize.large,
      );
    }
    if (seatId == null) {
      return AppButton.primary(
        label: l10n.coworkPickSeat,
        size: AppButtonSize.large,
        expanded: true,
        backgroundColor: colors.surface2,
        foregroundColor: colors.muted2,
      );
    }
    return AppButton.primary(
      label: l10n.coworkBook(
        seatId,
        formatClock(state.bookingUntil(state.current)),
      ),
      size: AppButtonSize.large,
      expanded: true,
      loading: state.saving,
      onPressed: state.saving ? null : onBook,
    );
  }
}
