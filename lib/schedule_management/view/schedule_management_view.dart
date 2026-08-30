part of 'schedule_management_page.dart';

class ScheduleManagementView extends StatelessWidget {
  const ScheduleManagementView({super.key});

  void _openAdd(BuildContext context) {
    unawaited(
      Navigator.of(
        context,
        rootNavigator: true,
      ).push(MaterialPageRoute<void>(builder: (_) => const AddSchedulePage())),
    );
  }

  void _openEdit(BuildContext context) {
    unawaited(
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute<void>(builder: (_) => const EditSchedulesPage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.canvas,
      floatingActionButton: NinjaFab(
        icon: const AppLineIconWidget(AppLineIcon.plus),
        tooltip: l10n.add,
        onPressed: () => _openAdd(context),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: colors.canvas,
            surfaceTintColor: Colors.transparent,
            title: Text(
              l10n.schedulesTitle,
              style: NinjaText.headline.copyWith(color: colors.ink),
            ),
            actions: [
              NinjaIconButton(
                icon: const AppLineIconWidget(AppLineIcon.search),
                tooltip: l10n.addScheduleTitle,
                onPressed: () => _openAdd(context),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
        body: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, state) => _HubBody(
            state: state,
            onAdd: () => _openAdd(context),
            onEdit: () => _openEdit(context),
          ),
        ),
      ),
    );
  }
}
