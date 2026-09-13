import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_scaffold.dart';

class ModuleUnavailablePage extends StatelessWidget {
  const ModuleUnavailablePage({super.key, this.signInRequired = false});

  final bool signInRequired;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MiniAppScaffold(
      title: l10n.universityModulesTitle,
      onBack: () => context.go('/services'),
      body: Center(
        child: SingleChildScrollView(
          child: NinjaEmptyState.screen(
            title: signInRequired
                ? l10n.universityModuleSignInTitle
                : l10n.universityModuleUnavailableTitle,
            message: signInRequired
                ? l10n.universityModuleSignInMessage
                : l10n.universityModuleUnavailableMessage,
            icon: const AppLineIconWidget(AppLineIcon.grid),
            actionLabel: l10n.universityModulesViewServices,
            onAction: () => context.go('/services'),
          ),
        ),
      ),
    );
  }
}
