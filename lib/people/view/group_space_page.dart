import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/people/cubit/group_space/group_space_cubit.dart';
import 'package:rtu_mirea_app/people/utils/external_link_launcher.dart';
import 'package:rtu_mirea_app/people/view/group_space_view.dart';

class GroupSpacePage extends StatelessWidget {
  const GroupSpacePage({super.key});

  @override
  Widget build(BuildContext context) {
    final initialPostId = GoRouterState.of(context).uri.queryParameters['post'];
    return RepositoryProvider(
      create: (_) => const ExternalLinkLauncher(),
      child: BlocProvider(
        create: (context) {
          final cubit = GroupSpaceCubit(
            repository: context.read(),
          );
          unawaited(cubit.load());
          return cubit;
        },
        child: GroupSpaceView(initialPostId: initialPostId),
      ),
    );
  }
}
