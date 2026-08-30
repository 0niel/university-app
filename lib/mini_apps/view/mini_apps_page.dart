import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_apps_catalog_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_stats_page.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/widgets.dart';

part 'mini_apps_view.dart';
part 'mini_apps_app_bar.dart';
part 'mini_apps_hero.dart';
part 'mini_apps_search_field.dart';
part 'mini_apps_sort_button.dart';
part 'mini_apps_sort_sheet.dart';
part 'sort_icon.dart';
part 'category_chips.dart';
part 'catalog_body.dart';
part 'recent_mini_apps.dart';
part 'catalog_section_label.dart';
part 'catalog_skeleton.dart';
part 'catalog_section_label_skeleton.dart';
part 'app_actions_sheet.dart';
part 'mini_app_action_tile.dart';

class MiniAppsPage extends StatelessWidget {
  const MiniAppsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = MiniAppsCatalogCubit(
          miniAppsRepository: context.read(),
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const MiniAppsView(),
    );
  }
}
