import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/grades/cubit/grades_cubit.dart';
import 'package:rtu_mirea_app/grades/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class GradesView extends StatelessWidget {
  const GradesView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppInnerHeader(
              title: l10n.gradesTitle,
              onBack: () => Navigator.of(context).maybePop(),
              backSemanticsLabel: l10n.back,
              actions: [
                AppHeaderAction(
                  icon: AppLineIcon.refresh,
                  semanticsLabel: l10n.gradesRefresh,
                  onTap: () => context.read<GradesCubit>().load(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              child: BlocBuilder<GradesCubit, GradesState>(
                builder: (context, state) => NinjaStateSwitcher(
                  child: switch (state.status) {
                    .failure => GradesErrorState(
                      key: const ValueKey('grades-error'),
                      savedAt: state.book.savedAt,
                      onRetry: () => context.read<GradesCubit>().load(),
                    ),
                    .initial || .loading => const GradesSkeleton(
                      key: ValueKey('grades-skeleton'),
                    ),
                    .ready => GradesContent(
                      key: const ValueKey('grades-content'),
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
