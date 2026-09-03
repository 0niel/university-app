import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/cowork/models/models.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

String formatClock(DateTime time) => DateFormat('HH:mm').format(time);

int hoursBetween(DateTime from, DateTime until) =>
    (until.difference(from).inMinutes / 60).round();

String coworkZoneLabel(AppLocalizations l10n, CoworkZone zone) =>
    switch (zone) {
      CoworkZone.quiet => l10n.coworkZoneQuiet,
      CoworkZone.common => l10n.coworkZoneCommon,
      CoworkZone.meeting => l10n.coworkZoneMeeting,
    };

(Color, Color) coworkSeatPalette(
  AppColors colors,
  CoworkSeatStatus status, {
  required bool selected,
}) {
  if (selected || status == CoworkSeatStatus.mine) {
    return (colors.accent, colors.onAccent);
  }
  return switch (status) {
    _ => (colors.surface2, colors.muted),
  };
}
