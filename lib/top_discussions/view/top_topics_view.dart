import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/top_discussions/bloc/discourse_bloc.dart';
import 'package:rtu_mirea_app/top_discussions/view/top_topics_content.dart';

class TopTopicsView extends StatelessWidget {
  const TopTopicsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiscourseBloc(
        context.read(),
      )..add(const DiscourseTopTopicsRequested()),
      child: const TopTopicsContent(),
    );
  }
}
