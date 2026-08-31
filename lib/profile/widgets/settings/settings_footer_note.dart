import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class SettingsFooterNote extends StatelessWidget {
  const SettingsFooterNote({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        20,
        NinjaMetrics.screenPadding,
        MediaQuery.paddingOf(context).bottom + 24,
      ),
      child: Text(
        context.l10n.settingsFooter,
        textAlign: TextAlign.center,
        style: NinjaText.helper.copyWith(color: colors.chevron),
      ),
    );
  }
}
