import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/cowork/cubit/cowork_cubit.dart';
import 'package:rtu_mirea_app/cowork/models/models.dart';
import 'package:rtu_mirea_app/cowork/utils/cowork_format.dart';
import 'package:rtu_mirea_app/cowork/widgets/cowork_book_button.dart';
import 'package:rtu_mirea_app/cowork/widgets/cowork_details_card.dart';
import 'package:rtu_mirea_app/cowork/widgets/cowork_seat_map.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CoworkContent extends StatelessWidget {
  const CoworkContent({required this.state, super.key});

  final CoworkState state;

  Future<void> _book(BuildContext context) async {
    final l10n = context.l10n;
    final booking = await context.read<CoworkCubit>().book();
    if (booking == null || !context.mounted) return;
    ToastManager.showSuccess(
      context,
      message: l10n.coworkBooked(
        booking.seatId,
        formatClock(booking.until),
      ),
    );
  }

  Future<void> _cancel(BuildContext context) async {
    final l10n = context.l10n;
    final removed = await context.read<CoworkCubit>().cancel();
    if (!context.mounted || !removed) return;
    ToastManager.showInfo(context, message: l10n.coworkBookingCancelled);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CoworkCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: AppChipGroup(
            spacing: 6,
            runSpacing: 6,
            chips: [
              for (final zone in CoworkZone.values)
                AppChip.filter(
                  label: coworkZoneLabel(l10n, zone),
                  selected: state.zone == zone,
                  onTap: () => cubit.zoneChanged(zone),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        CoworkSeatMap(
          seats: state.seats,
          selectedSeatId: state.selectedSeatId,
          onSeatTap: cubit.seatTapped,
        ),
        const SizedBox(height: 8),
        CoworkDetailsCard(state: state, onExtend: cubit.extend),
        const SizedBox(height: 14),
        if (state.saveFailed) ...[
          AppBanner(message: l10n.coworkSaveError, tone: AppBannerTone.danger),
          const SizedBox(height: 14),
        ],
        CoworkBookButton(
          state: state,
          onBook: () => _book(context),
          onCancel: () => _cancel(context),
        ),
        const SizedBox(height: 14),
        AppBanner(message: l10n.coworkLocalPlanHint),
      ],
    );
  }
}
