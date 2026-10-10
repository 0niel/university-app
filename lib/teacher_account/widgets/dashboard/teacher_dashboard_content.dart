import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/schedule/view/teacher_profile_page.dart';
import 'package:rtu_mirea_app/teacher_account/bloc/teacher_dashboard_bloc.dart';
import 'package:rtu_mirea_app/teacher_account/domain/teacher_workload.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_navigation.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/account_persona_sheet.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/dashboard.dart';

class TeacherDashboardContent extends StatelessWidget {
  const TeacherDashboardContent({super.key});

  void _refresh(BuildContext context, TeacherDashboardRefreshScope scope) =>
      context.read<TeacherDashboardBloc>().add(
        TeacherDashboardEvent.refreshRequested(scope: scope),
      );

  void _openSchedule(
    BuildContext context,
    TeacherScheduleDestination destination,
  ) => context.read<TeacherDashboardBloc>().add(
    TeacherDashboardEvent.openScheduleRequested(destination),
  );

  void _openLesson(BuildContext context, TeacherLessonOccurrence occurrence) {
    final teacher = context.read<TeacherDashboardBloc>().state.teacher;
    unawaited(
      ScheduleDetailsRoute(
        $extra: (occurrence.lesson, occurrence.date),
        teacherId: teacher?.uid,
        teacherName: teacher?.name,
      ).push<void>(context),
    );
  }

  void _openReviews(BuildContext context) {
    final state = context.read<TeacherDashboardBloc>().state;
    final teacher = state.teacher;
    if (teacher == null) return;
    unawaited(
      showTeacherProfileSheet(
        context,
        teacher: teacher,
        readOnly: true,
        initialProfile: state.rating.data?.copyWith(teacherName: teacher.name),
      ),
    );
  }

  void _search(BuildContext context, String query) =>
      unawaited(GlobalSearchRoute(query: query).push<void>(context));

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      BlocBuilder<TeacherDashboardBloc, TeacherDashboardState>(
        buildWhen: (previous, current) =>
            previous.teacher != current.teacher ||
            previous.now != current.now ||
            previous.rating != current.rating ||
            previous.preview != current.preview ||
            previous.navigation != current.navigation,
        builder: (context, state) => state.teacher == null
            ? const SizedBox.shrink()
            : TeacherDashboardIdentitySection(
                teacher: state.teacher!,
                rating: state.rating,
                preview: state.preview,
                now: state.now,
                navigationBusy: state.navigation.isBusy,
                onChangeTeacher: () =>
                    unawaited(showAccountPersonaSheet(context)),
                onOpenReviews: () => _openReviews(context),
                onRetryRating: () =>
                    _refresh(context, TeacherDashboardRefreshScope.rating),
                onOpenSchedule: () =>
                    _openSchedule(context, TeacherScheduleDestination.schedule),
                onOpenLesson: (lesson) => _openLesson(context, lesson),
              ),
      ),
      BlocBuilder<TeacherDashboardBloc, TeacherDashboardState>(
        buildWhen: (previous, current) =>
            previous.query != current.query ||
            previous.day != current.day ||
            previous.now != current.now ||
            previous.schedule != current.schedule ||
            previous.changes != current.changes,
        builder: (context, state) => TeacherDashboardScheduleSection(
          state: state,
          onChangeWeek: (delta) => context.read<TeacherDashboardBloc>().add(
            TeacherDashboardEvent.weekChanged(delta),
          ),
          onToday: () => context.read<TeacherDashboardBloc>().add(
            const TeacherDashboardEvent.todayRequested(),
          ),
          onSelectDay: (day) => context.read<TeacherDashboardBloc>().add(
            TeacherDashboardEvent.daySelected(day),
          ),
          onRetry: () =>
              _refresh(context, TeacherDashboardRefreshScope.schedule),
          onOpenLesson: (lesson) => _openLesson(context, lesson),
          onOpenGroup: (group) => _search(context, group.name),
          onOpenRoom: (room) => _search(context, room.name),
        ),
      ),
      BlocBuilder<TeacherDashboardBloc, TeacherDashboardState>(
        buildWhen: (previous, current) => previous.rating != current.rating,
        builder: (context, state) => TeacherDashboardRatingSection(
          resource: state.rating,
          onRetry: () => _refresh(context, TeacherDashboardRefreshScope.rating),
          onReviews: () => _openReviews(context),
        ),
      ),
      BlocSelector<TeacherDashboardBloc, TeacherDashboardState, bool>(
        selector: (state) => state.navigation.isBusy,
        builder: (context, busy) => TeacherDashboardServicesSection(
          navigationBusy: busy,
          onOpenChanges: () =>
              _openSchedule(context, TeacherScheduleDestination.changes),
          onExport: () =>
              _openSchedule(context, TeacherScheduleDestination.calendar),
        ),
      ),
    ],
  );
}
