import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class ServicesHeader extends StatelessWidget {
  const ServicesHeader({
    required this.editMode,
    required this.onToggleEdit,
    super.key,
  });

  final bool editMode;
  final VoidCallback onToggleEdit;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final label = editMode ? l10n.servicesEditDone : l10n.servicesConfigure;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        18,
        NinjaMetrics.screenPadding,
        16,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.services,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: NinjaText.display.copyWith(color: colors.ink),
            ),
          ),
          const SizedBox(width: 12),
          NinjaIconButton(
            key: const ValueKey('services-configure-button'),
            icon: AppLineIconWidget(
              editMode ? AppLineIcon.check : AppLineIcon.settings,
              size: 20,
            ),
            variant: editMode
                ? NinjaIconButtonVariant.filled
                : NinjaIconButtonVariant.outline,
            tooltip: label,
            onPressed: onToggleEdit,
          ),
        ],
      ),
    );
  }
}
