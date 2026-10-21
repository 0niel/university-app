import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_trending_group.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/top_discussions/top_discussions.dart';
import 'package:rtu_mirea_app/top_discussions/view/discourse_topic_utils.dart';

class HomeDashboardTrending extends StatelessWidget {
  const HomeDashboardTrending({super.key});

  @override
  Widget build(BuildContext context) => HomeTrendingGroup(
    state: context.watch<DiscourseBloc>().state,
    onAll: () => const CommunitiesRoute().go(context),
    onOpen: (topic) => unawaited(
      openDiscourseTopic(
        context.read<UniversityConfig>().communityForumUrl,
        topic.id,
      ),
    ),
    onRetry: () => context.read<DiscourseBloc>().add(
      const DiscourseTopTopicsRequested(),
    ),
  );
}
