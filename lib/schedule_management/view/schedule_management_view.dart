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
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.canvas,
      floatingActionButton: AppFab(
        icon: AppLineIcon.plus,
        tooltip: l10n.add,
        onPressed: () => _openAdd(context),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: AppInnerHeader(
              title: l10n.schedulesTitle,
              onBack: () => Navigator.of(context).maybePop(),
              actions: [
                AppHeaderAction(
                  icon: AppLineIcon.search,
                  semanticsLabel: l10n.addScheduleTitle,
                  onTap: () => _openAdd(context),
                ),
              ],
            ),
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
