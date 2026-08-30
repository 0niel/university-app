part of 'edit_schedules_page.dart';

class EditSchedulesView extends StatelessWidget {
  const EditSchedulesView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: colors.canvas,
            surfaceTintColor: Colors.transparent,
            title: Text(
              l10n.editSchedulesTitle,
              style: NinjaText.headline.copyWith(color: colors.ink),
            ),
            actions: [
              NinjaButton.text(
                label: l10n.done,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
        body: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (_, state) => _EditBody(state: state),
        ),
      ),
    );
  }
}
