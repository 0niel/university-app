import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_action_button.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_error_state.dart';
import 'package:flutter/widgets.dart';

class NinjaErrorCard extends StatelessWidget {
  const NinjaErrorCard({
    required this.title,
    required this.message,
    super.key,
    this.tone = NinjaErrorTone.danger,
    this.actionLabel,
    this.onAction,
  });
  final String title;
  final String message;
  final NinjaErrorTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final action = actionLabel;
    final accent = tone.accentOf(colors);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                  child: const SizedBox.square(dimension: 8),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: NinjaText.headline.copyWith(color: colors.ink),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              message,
              style: NinjaText.subtext.copyWith(color: colors.mutedDark),
            ),
          ),
          if (action != null) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: NinjaActionButton(
                label: action,
                onPressed: onAction,
                tone: NinjaActionTone.surface,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
