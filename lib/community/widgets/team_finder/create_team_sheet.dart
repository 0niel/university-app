import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/common/widgets/app_date_picker.dart';
import 'package:rtu_mirea_app/community/cubit/team_finder/team_finder.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/community/view/team_finder_labels.dart';
import 'package:rtu_mirea_app/community/widgets/team_finder/team_choice_chip.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

const _boostCost = 50;

class CreateTeamSheet extends StatefulWidget {
  const CreateTeamSheet({super.key, this.editing});

  final Team? editing;

  @override
  State<CreateTeamSheet> createState() => _CreateTeamSheetState();
}

class _CreateTeamSheetState extends State<CreateTeamSheet> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _customRole = TextEditingController();
  final Set<String> _roles = {};
  late String _kind =
      widget.editing?.kind ??
      UniversityConfig.current.teamKindKeys.firstOrNull ??
      'hackathon';
  late int _capacity = (widget.editing?.capacity ?? 5).clamp(2, _capacityMax);
  late DateTime? _deadline = widget.editing?.deadlineAt;
  var _boost = false;
  var _showCustomRoleInput = false;
  var _saving = false;
  var _submitted = false;
  var _failed = false;
  int? _walletBalance;

  int get _capacityMax => math.max(10, widget.editing?.capacity ?? 10);

  @override
  void initState() {
    super.initState();
    final editing = widget.editing;
    _title.text = editing?.title ?? '';
    _description.text = editing?.description ?? '';
    if (editing != null) {
      final known = UniversityConfig.current.teamRoleKeys.toSet();
      final custom = <String>[];
      for (final role in editing.neededRoles) {
        if (known.contains(role)) {
          _roles.add(role);
        } else {
          custom.add(role);
        }
      }
      if (custom.isNotEmpty) {
        _customRole.text = custom.join(', ');
        _showCustomRoleInput = true;
      }
    }
    _title.addListener(_onFieldChanged);
    _customRole.addListener(_onFieldChanged);
    if (editing == null) unawaited(_loadBalance());
  }

  @override
  void dispose() {
    _title
      ..removeListener(_onFieldChanged)
      ..dispose();
    _customRole
      ..removeListener(_onFieldChanged)
      ..dispose();
    _description.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadBalance() async {
    try {
      final profile = await context.read<GamificationRepository>().getProfile();
      if (mounted) setState(() => _walletBalance = profile.shurikens);
    } on Exception {
      if (mounted) setState(() => _walletBalance = null);
    }
  }

  List<String> get _customRoles => parseCustomRoles(_customRole.text);

  List<String> get _selectedRoles => [
    ..._roles,
    for (final role in _customRoles)
      if (!_roles.contains(role)) role,
  ];

  bool get _insufficientBoost =>
      _walletBalance != null && _walletBalance! < _boostCost;

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
    setState(() => _submitted = true);
    final title = _title.text.trim();
    final roles = _selectedRoles;
    if (title.isEmpty || roles.isEmpty) return;
    setState(() {
      _saving = true;
      _failed = false;
    });
    final draft = TeamDraft(
      title: title,
      description: _description.text,
      neededRoles: roles,
      capacity: _capacity,
      kind: _kind,
      deadlineAt: _deadline,
      boost: _boost && !_insufficientBoost,
    );
    final editing = widget.editing;
    final cubit = context.read<TeamFinderCubit>();
    final saved = editing == null
        ? await cubit.create(draft)
        : await cubit.update(editing, draft);
    if (!mounted) return;
    setState(() => _saving = false);
    if (saved) {
      final l10n = context.l10n;
      ToastManager.showSuccess(
        context,
        message: editing == null
            ? l10n.teamFinderTeamCreated
            : l10n.teamFinderTeamUpdated,
      );
      Navigator.of(context).pop(true);
    } else {
      setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final config = UniversityConfig.current;
    final editing = widget.editing;
    final titleError = _submitted && _title.text.trim().isEmpty
        ? l10n.teamFinderCreateTitleError
        : null;
    final rolesInvalid = _submitted && _selectedRoles.isEmpty;

    return SingleChildScrollView(
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_failed)
            AppBanner(
              message: editing == null
                  ? l10n.teamFinderCreateError
                  : l10n.teamFinderUpdateError,
              tone: AppBannerTone.danger,
            ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final kind in config.teamKindKeys)
                TeamChoiceChip(
                  enabled: !_saving,
                  label: teamKindLabel(context.l10n, kind),
                  selected: _kind == kind,
                  onPressed: () => setState(() => _kind = kind),
                ),
            ],
          ),
          AppInputField(
            controller: _title,
            autofocus: editing == null,
            enabled: !_saving,
            label: l10n.teamFinderCreateNameLabel,
            placeholder: l10n.teamFinderCreateNameHint,
            errorText: titleError,
          ),
          AppInputField.multiline(
            controller: _description,
            minLines: 2,
            maxLength: 4000,
            enabled: !_saving,
            label: l10n.teamFinderCreateDescriptionLabel,
            placeholder: l10n.teamFinderCreateDescriptionHint,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppFieldLabel(l10n.teamFinderCreateRolesLabel),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final role in config.teamRoleKeys)
                    TeamChoiceChip(
                      enabled: !_saving,
                      label: teamRoleLabel(context.l10n, role),
                      selected: _roles.contains(role),
                      onPressed: () => setState(() {
                        if (!_roles.remove(role)) _roles.add(role);
                      }),
                    ),
                  AppChip.filter(
                    label: l10n.teamFinderCreateOtherRole,
                    enabled: !_saving,
                    count: _customRoles.isEmpty ? null : _customRoles.length,
                    selected: _showCustomRoleInput || _customRoles.isNotEmpty,
                    onTap: () => setState(
                      () => _showCustomRoleInput = !_showCustomRoleInput,
                    ),
                  ),
                ],
              ),
              if (_showCustomRoleInput) ...[
                const SizedBox(height: AppSpacing.md),
                AppInputField(
                  controller: _customRole,
                  enabled: !_saving,
                  label: l10n.teamFinderCreateCustomRoleLabel,
                  placeholder: l10n.teamFinderCreateCustomRoleHint,
                  helperText: l10n.teamFinderCreateCustomRoleHelper,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
              if (rolesInvalid) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.teamFinderCreateRolesError,
                  style: AppText.caption.copyWith(color: colors.danger),
                ),
              ],
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppFieldLabel(l10n.teamFinderCreateSizeLabel),
              AppStepper(
                value: _capacity,
                min: 2,
                max: _capacityMax,
                decrementSemanticLabel: l10n.teamFinderDecreaseCapacity,
                incrementSemanticLabel: l10n.teamFinderIncreaseCapacity,
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _capacity = value),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppFieldLabel(l10n.teamFinderCreateDeadlineLabel),
              _DeadlineControl(
                deadline: _deadline,
                saving: _saving,
                onTap: _pickDeadline,
                onClear: () => setState(() => _deadline = null),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.teamFinderCreateDeadlineEmpty,
                style: AppText.caption.copyWith(color: colors.muted),
              ),
            ],
          ),
          if (editing == null)
            AppListGroup(
              children: [
                AppSettingsToggleRow(
                  title: l10n.teamFinderCreateBoostTitle,
                  subtitle: _insufficientBoost
                      ? l10n.teamFinderCreateBoostInsufficient(
                          _walletBalance ?? 0,
                        )
                      : l10n.teamFinderCreateBoostSubtitle,
                  value: _boost && !_insufficientBoost,
                  isFirst: true,
                  onChanged: _saving || _insufficientBoost
                      ? null
                      : (value) => setState(() => _boost = value),
                ),
              ],
            ),
          AppButton.primary(
            label: _saving
                ? (editing == null
                      ? l10n.teamFinderPublishing
                      : l10n.teamFinderSaving)
                : (editing == null
                      ? l10n.teamFinderPublish
                      : l10n.teamFinderSaveChanges),
            expanded: true,
            size: AppButtonSize.large,
            loading: _saving,
            onPressed: _saving ? null : () => unawaited(_save()),
          ),
        ],
      ),
    );
  }
}

class _DeadlineControl extends StatelessWidget {
  const _DeadlineControl({
    required this.deadline,
    required this.saving,
    required this.onTap,
    required this.onClear,
  });

  final DateTime? deadline;
  final bool saving;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final deadline = this.deadline;
    final label = deadline == null
        ? l10n.teamFinderCreateDeadlinePlaceholder
        : l10n.teamFinderDeadlineUntil(formatTeamDate(context, deadline));

    return Row(
      children: [
        Expanded(
          child: AppPressable(
            enabled: !saving,
            onTap: saving ? null : onTap,
            semanticsLabel: label,
            semanticsButton: true,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppRadius.field),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 56),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: AppText.body.copyWith(color: colors.ink),
                        ),
                      ),
                      AppLineIconWidget(
                        AppLineIcon.calendar,
                        size: 17,
                        color: colors.muted,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (deadline != null) ...[
          const SizedBox(width: AppSpacing.sm),
          AppIconButton(
            icon: const AppLineIconWidget(AppLineIcon.close),
            tooltip: l10n.teamFinderRemoveDeadline,
            size: AppIconButtonSize.compact,
            onPressed: saving ? null : onClear,
          ),
        ],
      ],
    );
  }
}
