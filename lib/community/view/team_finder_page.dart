import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/team_finder/team_finder.dart';
import 'package:rtu_mirea_app/community/view/team_finder_view.dart';

class TeamFinderPage extends StatelessWidget {
  const TeamFinderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = TeamFinderCubit(context.read());
        unawaited(cubit.load());
        return cubit;
      },
      child: const TeamFinderView(),
    );
  }
}
