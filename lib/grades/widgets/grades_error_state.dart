import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class GradesErrorState extends StatelessWidget {
  const GradesErrorState({super.key, this.savedAt, this.onRetry});

  final DateTime? savedAt;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final savedAt = this.savedAt;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: AppErrorState(
        title: l10n.gradesErrorTitle,
        message: savedAt == null
            ? l10n.gradesErrorNoData
            : l10n.gradesErrorSaved(
                DateFormat('d MMMM', locale).format(savedAt),
              ),
        footnote: null,
        primaryLabel: l10n.retry,
        onPrimary: onRetry,
      ),
    );
  }
}
