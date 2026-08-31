import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/knowledge_bank/cubit/knowledge_bank_cubit.dart';
import 'package:rtu_mirea_app/knowledge_bank/view/knowledge_bank_view.dart';

class KnowledgeBankPage extends StatelessWidget {
  const KnowledgeBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = KnowledgeBankCubit(
          campusRepository: context.read(),
          gamificationRepository: context.read(),
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const KnowledgeBankView(),
    );
  }
}
