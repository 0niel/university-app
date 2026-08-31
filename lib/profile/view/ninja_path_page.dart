import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/profile/cubit/ninja_path_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/ninja_path_view.dart';

class NinjaPathPage extends StatelessWidget {
  const NinjaPathPage({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (providerContext) {
        final cubit = NinjaPathCubit(
          gamificationRepository: providerContext.read(),
          organizationId: providerContext
              .read<UniversityConfig>()
              .organizationId,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: NinjaPathView(initialTab: initialTab),
    );
  }
}
