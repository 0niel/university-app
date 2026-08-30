import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/wallet/cubit/wallet_cubit.dart';
import 'package:rtu_mirea_app/wallet/view/wallet_view.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = WalletCubit(
          gamificationRepository: context.read(),
          organizationId: context.read<UniversityConfig>().organizationId,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const WalletView(),
    );
  }
}
