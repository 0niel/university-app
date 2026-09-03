import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/contributors/bloc/contributors_bloc.dart';
import 'package:rtu_mirea_app/tools/cubit/tools_cubit.dart';
import 'package:rtu_mirea_app/tools/view/tools_view.dart';

export 'tools_view.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ToolsCubit()),
        BlocProvider(
          create: (context) => ContributorsBloc(
            communityRepository: context.read(),
          )..add(const ContributorsRequested()),
        ),
      ],
      child: const ToolsView(),
    );
  }
}
