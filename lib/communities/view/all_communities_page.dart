import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/communities/communities.dart';

class AllCommunitiesPage extends StatelessWidget {
  const AllCommunitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = CommunityCatalogCubit(repository: context.read());
            unawaited(cubit.load(locale: locale));
            return cubit;
          },
        ),
        BlocProvider(create: (_) => JoinedCommunitiesCubit()),
      ],
      child: const AllCommunitiesView(),
    );
  }
}
