import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule_management/widgets/widgets.dart';

class ScheduleManagementPage extends StatefulWidget {
  const ScheduleManagementPage({super.key});

  @override
  State<ScheduleManagementPage> createState() => _ScheduleManagementPageState();
}

class _ScheduleManagementPageState extends State<ScheduleManagementPage> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Группы', 'Преподаватели', 'Аудитории'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписания'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          IconButton(
            onPressed: () => context.push('/schedule/search'),
            icon: const Icon(Icons.add),
            tooltip: 'Добавить расписание',
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab bar
          Container(
            color: theme.scaffoldBackgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: CategoryAnimatedTabBar(
              tabs: _tabs,
              selectedIndex: _selectedTabIndex,
              onTap: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
            ),
          ),

          // Main content
          Expanded(
            child: BlocBuilder<ScheduleBloc, ScheduleState>(
              builder: (context, state) {
                // Check if there's an active schedule
                final hasActiveSchedule = state.selectedSchedule != null;

                return Column(
                  children: [
                    // Active schedule banner
                    if (hasActiveSchedule)
                      Container(
                            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [appColors.primary.withOpacity(0.1), appColors.primary.withOpacity(0.05)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: appColors.primary.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.check_rounded, color: appColors.primary, size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Активное расписание',
                                        style: AppTextStyle.bodyBold.copyWith(color: appColors.primary, fontSize: 14),
                                      ),
                                      Text(
                                        state.selectedSchedule!.name,
                                        style: AppTextStyle.body.copyWith(
                                          color: appColors.active.withOpacity(0.8),
                                          fontSize: 13,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => context.go('/schedule'),
                                  icon: Icon(Icons.visibility, color: appColors.primary, size: 18),
                                  visualDensity: VisualDensity.compact,
                                  tooltip: 'Перейти к просмотру',
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .scale(begin: const Offset(0.98, 0.98), end: const Offset(1.0, 1.0), duration: 300.ms),

                    // Main content
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<ScheduleBloc>().add(const RefreshSelectedScheduleData());
                          await Future.delayed(const Duration(milliseconds: 800));
                        },
                        child: IndexedStack(
                          index: _selectedTabIndex,
                          children: [
                            _buildGroupTab(context, state),
                            _buildTeacherTab(context, state),
                            _buildClassroomTab(context, state),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isCurrentTabEmpty(ScheduleState state) {
    if (state.status == ScheduleStatus.loading) return false;

    switch (_selectedTabIndex) {
      case 0:
        return state.groupsSchedule.isEmpty;
      case 1:
        return state.teachersSchedule.isEmpty;
      case 2:
        return state.classroomsSchedule.isEmpty;
      default:
        return false;
    }
  }

  Widget _buildGroupTab(BuildContext context, ScheduleState state) {
    if (state.status == ScheduleStatus.loading) {
      return _buildLoadingState(context);
    }

    if (state.status == ScheduleStatus.failure) {
      return _buildErrorState(context);
    }

    if (state.groupsSchedule.isEmpty) {
      return _buildEmptyTabContent(context, 'Нет добавленных групп', 'Добавьте группу, чтобы видеть её расписание');
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: state.groupsSchedule.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final schedule = state.groupsSchedule[index];
        return ScheduleCard(
          schedule: schedule,
          state: state,
          scheduleType: 'group',
        ).animate(delay: (50 * index).milliseconds).fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0);
      },
    );
  }

  Widget _buildTeacherTab(BuildContext context, ScheduleState state) {
    if (state.status == ScheduleStatus.loading) {
      return _buildLoadingState(context);
    }

    if (state.status == ScheduleStatus.failure) {
      return _buildErrorState(context);
    }

    if (state.teachersSchedule.isEmpty) {
      return _buildEmptyTabContent(
        context,
        'Нет добавленных преподавателей',
        'Добавьте преподавателя, чтобы видеть его расписание',
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: state.teachersSchedule.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final schedule = state.teachersSchedule[index];
        return ScheduleCard(
          schedule: schedule,
          state: state,
          scheduleType: 'teacher',
        ).animate(delay: (50 * index).milliseconds).fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0);
      },
    );
  }

  Widget _buildClassroomTab(BuildContext context, ScheduleState state) {
    if (state.status == ScheduleStatus.loading) {
      return _buildLoadingState(context);
    }

    if (state.status == ScheduleStatus.failure) {
      return _buildErrorState(context);
    }

    if (state.classroomsSchedule.isEmpty) {
      return _buildEmptyTabContent(
        context,
        'Нет добавленных аудиторий',
        'Добавьте аудиторию, чтобы видеть её расписание',
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: state.classroomsSchedule.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final schedule = state.classroomsSchedule[index];
        return ScheduleCard(
          schedule: schedule,
          state: state,
          scheduleType: 'classroom',
        ).animate(delay: (50 * index).milliseconds).fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0);
      },
    );
  }

  Widget _buildEmptyTabContent(BuildContext context, String title, String subtitle) {
    return FailureScreen(
      title: title,
      description: subtitle,
      icon: HugeIcons.strokeRoundedCalendar04,
      buttonText: 'Добавить',
      onButtonPressed: () => context.push('/schedule/search'),
      iconSize: 64,
    ).animate().fadeIn(duration: 500.ms).slide(begin: const Offset(0, 0.1), end: Offset.zero, duration: 500.ms);
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text('Загрузка расписаний...', style: Theme.of(context).textTheme.bodyLarge),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return FailureScreen(
      title: 'Не удалось загрузить расписания',
      description: 'Проверьте подключение к интернету',
      icon: Icons.error_outline_rounded,
      iconSize: 64,
      iconColor: Theme.of(context).colorScheme.error,
      buttonText: 'Повторить',
      buttonIcon: Icons.refresh,
      onButtonPressed: () => context.read<ScheduleBloc>().add(const RefreshSelectedScheduleData()),
    ).animate().fadeIn(duration: 400.ms);
  }
}
