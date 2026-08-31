import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/common/widgets/app_date_picker.dart';
import 'package:rtu_mirea_app/community/cubit/team_finder/team_finder.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/community/view/team_finder_labels.dart';
import 'package:rtu_mirea_app/community/widgets/team_finder/team_choice_chip.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CreateTeamSheet extends StatefulWidget {
  const CreateTeamSheet({super.key});

  @override
  State<CreateTeamSheet> createState() => _CreateTeamSheetState();
}

class _CreateTeamSheetState extends State<CreateTeamSheet> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final Set<String> _roles = {};
  late String _kind =
      UniversityConfig.current.teamKindKeys.firstOrNull ?? 'hackathon';
  var _capacity = 5;
  DateTime? _deadline;
  var _boost = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final date = await showAppDatePicker(
      context,
      initial: _deadline ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 730)),
    );
    if (date != null && mounted) {
      setState(
        () => _deadline = DateTime(date.year, date.month, date.day, 23, 59),
      );
    }
  }

  Future<void> _save() async {
    final saved = await context.read<TeamFinderCubit>().create(
      TeamDraft(
        title: _title.text,
        description: _description.text,
        neededRoles: _roles.toList(growable: false),
        capacity: _capacity,
        kind: _kind,
        deadlineAt: _deadline,
        boost: _boost,
      ),
    );
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop(true);
    } else {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.teamFinderCreateError,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = UniversityConfig.current;
    final saving = context.select<TeamFinderCubit, bool>(
      (cubit) => cubit.state.isCreating,
    );
    return SingleChildScrollView(
      child: Column(
        spacing: 16,
        crossAxisAlignment: .start,
        children: [
          NinjaSegmented<String>(
            value: _kind,
            expanded: true,
            onChanged: saving ? null : (value) => setState(() => _kind = value),
            segments: [
              for (final kind in config.teamKindKeys)
                NinjaSegment(
                  value: kind,
                  label: teamKindLabel(context.l10n, kind),
                ),
            ],
          ),
          NinjaInput(
            controller: _title,
            autofocus: true,
            enabled: !saving,
            label: context.l10n.teamFinderCreateNameLabel,
            placeholder: context.l10n.teamFinderCreateNameHint,
          ),
          NinjaInput.multiline(
            controller: _description,
            minLines: 2,
            maxLines: 4,
            maxLength: 4000,
            enabled: !saving,
            label: context.l10n.teamFinderCreateDescriptionLabel,
            placeholder: context.l10n.teamFinderCreateDescriptionHint,
          ),
          Text(
            context.l10n.teamFinderCreateRolesLabel,
            style: NinjaText.microLabel.copyWith(
              color: context.ninja.muted,
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final role in config.teamRoleKeys)
                TeamChoiceChip(
                  label: teamRoleLabel(context.l10n, role),
                  selected: _roles.contains(role),
                  onPressed: () => setState(() {
                    if (!_roles.remove(role)) _roles.add(role);
                  }),
                ),
            ],
          ),
          _capacityControl(context, saving: saving),
          _deadlineControl(context, saving: saving),
          NinjaListCell(
            title: context.l10n.teamFinderCreateBoostTitle,
            subtitle: context.l10n.teamFinderCreateBoostSubtitle,
            horizontalPadding: 0,
            showChevron: false,
            trailing: NinjaSwitch(
              value: _boost,
              onChanged: saving
                  ? null
                  : (value) => setState(() => _boost = value),
            ),
          ),
          NinjaButton.primary(
            label: saving
                ? context.l10n.teamFinderPublishing
                : context.l10n.teamFinderPublish,
            expanded: true,
            size: NinjaButtonSize.large,
            onPressed: saving ? null : () => unawaited(_save()),
          ),
        ],
      ),
    );
  }

  Widget _capacityControl(BuildContext context, {required bool saving}) {
    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: context.ninja.surface,
        borderRadius: .circular(NinjaRadius.button),
      ),
      child: Row(
        spacing: 4,
        children: [
          Expanded(child: Text(context.l10n.teamFinderCreateSizeLabel)),
          NinjaIconButton(
            tooltip: context.l10n.teamFinderDecreaseCapacity,
            onPressed: saving || _capacity <= 2
                ? null
                : () => setState(() => _capacity--),
            icon: const AppLineIconWidget(.minus, size: 16),
          ),
          SizedBox(
            width: 44,
            child: Text('$_capacity', textAlign: .center),
          ),
          NinjaIconButton(
            tooltip: context.l10n.teamFinderIncreaseCapacity,
            onPressed: saving || _capacity >= 20
                ? null
                : () => setState(() => _capacity++),
            icon: const AppLineIconWidget(.plus, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _deadlineControl(BuildContext context, {required bool saving}) {
    final colors = context.ninja;
    final deadline = _deadline;
    final label = deadline == null
        ? context.l10n.teamFinderCreateDeadlineEmpty
        : context.l10n.teamFinderDeadlineUntil(
            formatTeamDate(context, deadline),
          );
    return AppPressable(
      enabled: !saving,
      onTap: saving ? null : () => unawaited(_pickDeadline()),
      semanticsLabel: label,
      semanticsButton: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.control),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const .symmetric(horizontal: 14, vertical: 10),
            child: Row(
              spacing: 10,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: NinjaText.body.copyWith(color: colors.ink),
                  ),
                ),
                AppLineIconWidget(.calendar, size: 17, color: colors.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
