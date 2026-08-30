import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/discourse_post_overview/bloc/post_overview_bloc.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_body.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class DiscoursePostOverviewPageView extends StatelessWidget {
  const DiscoursePostOverviewPageView({required this.postId, super.key});

  final int postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.ninja.canvas,
      body: BlocProvider<PostOverviewBloc>(
        create: (context) => PostOverviewBloc(
          communityRepository: context.read(),
        )..add(PostRequested(postId: postId)),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NinjaAppBar.inner(
                title: context.l10n.postDetailTitle,
                backSemanticLabel: context.l10n.back,
                onBack: () => Navigator.of(context).maybePop(),
              ),
              Expanded(child: PostOverviewBody(postId: postId)),
            ],
          ),
        ),
      ),
    );
  }
}
