import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

String formatMediaSize(AppLocalizations l10n, int? bytes) {
  if (bytes == null || bytes <= 0) return l10n.lessonDetailsFile;
  if (bytes < 1024 * 1024) {
    return l10n.lessonFileKilobytes(
      NumberFormat('0', l10n.localeName).format(bytes / 1024),
    );
  }
  return l10n.lessonFileMegabytes(
    NumberFormat('0.0', l10n.localeName).format(bytes / (1024 * 1024)),
  );
}
