import 'dart:async';

import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/team_applications/team_applications.dart';
import 'package:rtu_mirea_app/community/widgets/team_finder/team_applications_body.dart';

class TeamApplicationsSheet extends StatelessWidget {
  const TeamApplicationsSheet({
    required this.team,
    required this.onTelegram,
    required this.onChanged,
    super.key,
  });

  final Team team;
  final ValueChanged<TeamApplication> onTelegram;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = TeamApplicationsCubit(
          context.read(),
          team.id,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: TeamApplicationsBody(
        onTelegram: onTelegram,
        onChanged: onChanged,
      ),
    );
  }
}
