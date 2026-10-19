import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_picker_menu.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_picker_options.dart';

class SchedulePickerButton extends StatefulWidget {
  const SchedulePickerButton({super.key, this.name, this.semanticsLabel});

  final String? name;
  final String? semanticsLabel;

  @override
  State<SchedulePickerButton> createState() => _SchedulePickerButtonState();
}

class _SchedulePickerButtonState extends State<SchedulePickerButton> {
  Future<SchedulePickerChoice?>? _choice;

  Future<void> _open(BuildContext anchorContext) async {
    if (_choice != null) return;
    final bloc = context.read<ScheduleBloc>();
    final choice = showAppPopover<SchedulePickerChoice>(
      context,
      anchorContext: anchorContext,
      semanticLabel: context.l10n.selectSchedule,
      maxWidth: 320,
      maxHeight: 360,
      builder: (_) => SchedulePickerMenu(bloc: bloc),
    );
    setState(() {
      _choice = choice;
    });
    final result = await choice;
    if (!mounted) return;
    setState(() => _choice = null);
    switch (result) {
      case SchedulePickerSelection(:final schedule):
        if (bloc.state.selectedSchedule?.pickerId != schedule.pickerId) {
          bloc.add(ScheduleSelected(selectedSchedule: schedule));
        }
      case SchedulePickerManagement():
        unawaited(const ScheduleManagementRoute().push(context));
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Builder(
      builder: (anchorContext) => Semantics(
        expanded: _choice != null,
        child: AppPressable(
          onTap: () => unawaited(_open(anchorContext)),
          semanticsLabel:
              widget.semanticsLabel ??
              widget.name ??
              anchorContext.l10n.schedules,
          child: AppGlassSurface(
            role: AppGlassRole.control,
            borderRadius: AppRadius.full,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sectionGap,
              vertical: AppSpacing.gap,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 24),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.name ?? anchorContext.l10n.schedules,
                        maxLines: 1,
                        softWrap: false,
                        style: AppText.labelStrong.copyWith(color: colors.ink),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xsm),
                  AnimatedRotation(
                    turns: _choice == null ? 0 : .5,
                    duration: NinjaMotion.of(anchorContext, NinjaMotion.fast),
                    curve: NinjaMotion.enter,
                    child: AppLineIconWidget(
                      AppLineIcon.chevronD,
                      size: 14,
                      color: colors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
