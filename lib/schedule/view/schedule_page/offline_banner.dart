part of '../schedule_page.dart';

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner({this.lastSyncedAt});

  final DateTime? lastSyncedAt;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        14,
        NinjaMetrics.screenPadding,
        0,
      ),
      child: NinjaBanner(
        tone: .warn,
        title: l10n.offlineFromCache,
        body: l10n.updatedAtTime(
          DateFormat('HH:mm').format(lastSyncedAt ?? DateTime.now()),
        ),
      ),
    );
  }
}
