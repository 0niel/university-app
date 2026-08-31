import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/common/widgets/ninja_form_input.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/search/widgets/global_search_button.dart';

part 'custom_schedules_create_form.dart';
part 'custom_schedules_empty_state.dart';
part 'custom_schedules_more_button.dart';

class CustomSchedulesPage extends StatefulWidget {
  const CustomSchedulesPage({super.key});

  @override
  State<CustomSchedulesPage> createState() => _CustomSchedulesPageState();
}

class _CustomSchedulesPageState extends State<CustomSchedulesPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: BlocBuilder<CustomScheduleCubit, CustomScheduleState>(
        builder: (context, state) {
          final schedules = state.customSchedules;
          return CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverAppBar(
                elevation: 0,
                scrolledUnderElevation: 0,
                backgroundColor: colors.canvas,
                surfaceTintColor: Colors.transparent,
                title: Text(
                  l10n.mySchedules,
                  style: NinjaText.headline.copyWith(color: colors.ink),
                ),
                actions: [
                  NinjaIconButton(
                    icon: const AppLineIconWidget(.search, size: 20),
                    tooltip: l10n.customSchedulesSearchTitle,
                    onPressed: () => openGlobalSearch(context),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              SliverSafeArea(
                top: false,
                sliver: SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    NinjaMetrics.screenPadding,
                    8,
                    NinjaMetrics.screenPadding,
                    32,
                  ),
                  sliver: SliverList.list(
                    children: [
                      CustomScheduleSyncBanner(
                        status: state.syncStatus,
                        onRetry: () => unawaited(
                          context
                              .read<CustomScheduleCubit>()
                              .flushRemotePreferences(),
                        ),
                      ),
                      if (state.syncStatus != .initial &&
                          state.syncStatus != .synced)
                        const SizedBox(height: 10),
                      NinjaScheduleSurface(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            NinjaListCell(
                              title: l10n.customSchedulesSearchTitle,
                              subtitle: l10n.customSchedulesSearchSubtitle,
                              onTap: () => openGlobalSearch(context),
                            ),
                            NinjaListCell(
                              title: l10n.customSchedulesCreate,
                              subtitle: l10n.customSchedulesCreateSubtitle,
                              onTap: _showCreateScheduleDialog,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      if (schedules.isEmpty)
                        _CustomSchedulesEmptyState(
                          onCreate: _showCreateScheduleDialog,
                        )
                      else ...[
                        NinjaScheduleSectionHeader(
                          title: l10n.customSchedulesMyCount(schedules.length),
                        ),
                        const SizedBox(height: 10),
                        NinjaScheduleSurface(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              for (final schedule in schedules)
                                NinjaListCell(
                                  key: ValueKey(
                                    'custom_schedule_${schedule.id}',
                                  ),
                                  title: schedule.name,
                                  subtitle: _scheduleSubtitle(l10n, schedule),
                                  trailing: _CustomSchedulesMoreButton(
                                    onTap: () => _showScheduleMenu(schedule),
                                  ),
                                  onTap: () => _editSchedule(schedule),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _editSchedule(CustomSchedule schedule) {
    unawaited(context.push('/schedule/edit/${schedule.id}'));
  }

  void _selectCustomSchedule(CustomSchedule schedule) {
    final selected = context.read<CustomScheduleCubit>().buildSelectedSchedule(
      schedule.id,
    );
    if (selected != null) {
      context.read<ScheduleBloc>().add(
        ScheduleSelected(selectedSchedule: selected),
      );
    }
    context.go('/schedule');
  }

  Future<void> _showScheduleMenu(CustomSchedule schedule) async {
    await showAppSheet<void>(
      context,
      title: schedule.name,
      child: Column(
        mainAxisSize: .min,
        children: [
          NinjaListCell(
            title: context.l10n.customSchedulesOpen,
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              _selectCustomSchedule(schedule);
            },
          ),
          NinjaListCell(
            title: context.l10n.customSchedulesRename,
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              _showEditDialog(schedule);
            },
          ),
          NinjaListCell(
            title: context.l10n.delete,
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              _showDeleteConfirmation(schedule);
            },
          ),
        ],
      ),
    );
  }

  void _showCreateScheduleDialog() {
    _nameController.clear();
    _descriptionController.clear();

    unawaited(
      showAppSheet<void>(
        context,
        title: context.l10n.customSchedulesCreateTitle,
        subtitle: context.l10n.customSchedulesCreateDesc,
        child: _CustomSchedulesCreateForm(
          formKey: _formKey,
          nameController: _nameController,
          descriptionController: _descriptionController,
          onSubmit: () {
            if (_formKey.currentState?.validate() ?? false) {
              final schedule = context.read<CustomScheduleCubit>().create(
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim(),
              );
              Navigator.of(context, rootNavigator: true).pop();
              unawaited(context.push('/schedule/edit/${schedule.id}'));
            }
          },
        ),
      ),
    );
  }

  void _showEditDialog(CustomSchedule schedule) {
    _nameController.text = schedule.name;
    _descriptionController.text = schedule.description ?? '';

    unawaited(
      showAppSheet<void>(
        context,
        title: context.l10n.customSchedulesEditTitle,
        subtitle: context.l10n.customSchedulesEditDesc,
        child: _CustomSchedulesCreateForm(
          formKey: _formKey,
          nameController: _nameController,
          descriptionController: _descriptionController,
          isEditing: true,
          onSubmit: () {
            if (_formKey.currentState?.validate() ?? false) {
              context.read<CustomScheduleCubit>().update(
                schedule.copyWith(
                  name: _nameController.text.trim(),
                  description: _descriptionController.text.trim().isNotEmpty
                      ? _descriptionController.text.trim()
                      : null,
                  updatedAt: DateTime.now(),
                ),
              );
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(CustomSchedule schedule) {
    unawaited(
      showNinjaConfirmDialog(
        context,
        title: context.l10n.deleteSchedule,
        message: context.l10n.deleteScheduleConfirm(schedule.name),
        confirmLabel: context.l10n.delete,
        cancelLabel: context.l10n.cancel,
        destructive: true,
      ).then((confirmed) {
        if (confirmed && mounted) {
          context.read<CustomScheduleCubit>().delete(schedule.id);
        }
      }),
    );
  }
}

String _formatUpdateTime(AppLocalizations l10n, DateTime? dateTime) {
  if (dateTime == null) return l10n.customSchedulesUnknown;
  final difference = DateTime.now().difference(dateTime);
  if (difference.inDays > 7) return DateFormat('dd.MM.yy').format(dateTime);
  if (difference.inDays > 0) {
    return l10n.customSchedulesDaysAgo(difference.inDays);
  }
  if (difference.inHours > 0) {
    return l10n.customSchedulesHoursAgo(difference.inHours);
  }
  if (difference.inMinutes > 0) {
    return l10n.customSchedulesMinutesAgo(difference.inMinutes);
  }
  return l10n.customSchedulesJustNow;
}

String _scheduleSubtitle(
  AppLocalizations l10n,
  CustomSchedule schedule,
) {
  final lessons = l10n.customSchedulesLessonsCount(schedule.lessons.length);
  final updated = l10n.customSchedulesUpdated(
    _formatUpdateTime(l10n, schedule.updatedAt),
  );
  return '$lessons · $updated';
}
