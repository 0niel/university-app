import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/communities/communities.dart';

class CommunitiesPreview extends StatelessWidget {
  const CommunitiesPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return BlocProvider(
      create: (context) {
        final cubit = CommunityCatalogCubit(repository: context.read());
        unawaited(cubit.load(locale: locale));
        return cubit;
      },
      child: const CommunitiesPreviewView(),
    );
  }
}
