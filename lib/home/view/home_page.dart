import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>().checkOnboarding();
    return BlocConsumer<HomeCubit, HomeState>(builder: (context, state) {
      return Container();
    }, listener: (context, state) {
      if (state is AppOnboarding) {
        // replace to avoid display bottom nav bar
        context.replace('/onboarding');
      } else {
        context.go('/schedule');
      }
    });
  }
}
