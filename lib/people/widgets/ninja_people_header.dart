import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaPeopleHeader extends StatelessWidget {
  const NinjaPeopleHeader({
    required this.title,
    required this.search,
    required this.addLabel,
    required this.onAdd,
    super.key,
  });

  final String title;
  final Widget search;
  final String addLabel;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final compact = MediaQuery.textScalerOf(context).scale(1) >= 1.6;
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        10,
        NinjaMetrics.screenPadding,
        2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: .ellipsis,
              style: (compact ? NinjaText.title : NinjaText.display).copyWith(
                color: colors.ink,
              ),
            ),
          ),
          search,
          const SizedBox(width: 8),
          Semantics(
            button: true,
            label: addLabel,
            child: NinjaIconButton(
              icon: const AppLineIconWidget(.plus, size: 20),
              tooltip: addLabel,
              onPressed: onAdd,
            ),
          ),
        ],
      ),
    );
  }
}
