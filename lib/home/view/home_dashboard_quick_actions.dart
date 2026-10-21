import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_quick_actions.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/services/services.dart';

class HomeDashboardQuickActions extends StatelessWidget {
  const HomeDashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoriteServicesCubit>().state;
    final catalog = context.watch<ServiceCatalogCubit>().state;
    final services = ServicesDirectory.orderedEntries(
      ServicesDirectory.sections(
        context,
        config: context.read(),
        catalog: catalog.catalog,
      ).expand((section) => section.entries),
      favorites.ids,
    );
    return HomeQuickActions(
      services: services,
      loading: !favorites.loaded || catalog.isLoading,
      onAll: () => const ServicesRoute().go(context),
    );
  }
}
