import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_stats_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_scaffold.dart';

part 'mini_app_stats_view.dart';
part 'range_selector.dart';
part 'stats_content.dart';
part 'stats_body.dart';
part 'stats_skeleton.dart';
part 'stats_chart.dart';
part 'left_label.dart';
part 'bottom_label.dart';
part 'total_card.dart';
part 'totals_strip.dart';
part 'legend_dot.dart';

class MiniAppStatsPage extends StatelessWidget {
  const MiniAppStatsPage({
    required this.app,
    required this.repository,
    super.key,
  });

  final MiniApp app;

  final MiniAppsRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = MiniAppStatsCubit(
          miniAppsRepository: repository,
          appId: app.id,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: MiniAppStatsView(app: app),
    );
  }
}
