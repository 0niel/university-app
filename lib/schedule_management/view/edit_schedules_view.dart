part of 'edit_schedules_page.dart';

class EditSchedulesView extends StatelessWidget {
  const EditSchedulesView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              child: AppInnerHeader(
                title: l10n.editSchedulesTitle,
                onBack: () => Navigator.of(context).maybePop(),
                trailingLabel: l10n.done,
                onTrailingLabelTap: () => Navigator.of(context).maybePop(),
              ),
            ),
          ),
        ],
        body: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (_, state) => _EditBody(state: state),
        ),
      ),
    );
  }
}
