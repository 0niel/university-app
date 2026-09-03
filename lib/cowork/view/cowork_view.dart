import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/cowork/cubit/cowork_cubit.dart';
import 'package:rtu_mirea_app/cowork/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CoworkView extends StatelessWidget {
  const CoworkView({super.key});

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
            const CoworkHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              child: BlocBuilder<CoworkCubit, CoworkState>(
                builder: (context, state) => NinjaStateSwitcher(
                  child: switch (state.status) {
                    CoworkStatus.failure => Padding(
                      key: const ValueKey('cowork-error'),
                      padding: const EdgeInsets.only(top: 80),
                      child: NinjaErrorState(
                        title: l10n.gradesErrorTitle,
                        retryLabel: l10n.retry,
                        onRetry: () => context.read<CoworkCubit>().load(),
                      ),
                    ),
                    CoworkStatus.initial ||
                    CoworkStatus.loading => const CoworkSkeleton(
                      key: ValueKey('cowork-skeleton'),
                    ),
                    CoworkStatus.ready => CoworkContent(
                      key: const ValueKey('cowork-content'),
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
