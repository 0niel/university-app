import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/attendance/cubit/attendance_cubit.dart';
import 'package:rtu_mirea_app/attendance/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: ninjaBottomInset(context) + AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AttendanceHeader(
              onAdd: () => showAddAbsenceSheet(
                context,
                cubit: context.read<AttendanceCubit>(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              child: BlocBuilder<AttendanceCubit, AttendanceState>(
                builder: (context, state) => NinjaStateSwitcher(
                  child: switch (state.status) {
                    .failure => Padding(
                      key: const ValueKey('attendance-error'),
                      padding: const EdgeInsets.only(top: 80),
                      child: AppErrorState(
                        title: l10n.gradesErrorTitle,
                        message: null,
                        footnote: null,
                        primaryLabel: l10n.retry,
                        onPrimary: () => context.read<AttendanceCubit>().load(),
                      ),
                    ),
                    .initial || .loading => const AttendanceSkeleton(
                      key: ValueKey('attendance-skeleton'),
                    ),
                    .ready => AttendanceContent(
                      key: const ValueKey('attendance-content'),
                      state: state,
                    ),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
