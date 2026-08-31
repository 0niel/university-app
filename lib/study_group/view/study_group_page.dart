import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';
import 'package:rtu_mirea_app/community/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/study_group/cubit/study_group_cubit.dart';
import 'package:rtu_mirea_app/study_group/widgets/widgets.dart';
import 'package:study_groups_repository/study_groups_repository.dart';

part 'ninja_study_group_content.dart';
part 'ninja_study_group_hero_card.dart';
part 'ninja_study_group_member_row.dart';
part 'ninja_study_group_request_card.dart';
part 'ninja_study_group_section_header.dart';
part 'ninja_study_group_skeleton.dart';
part 'placeholder.dart';
part 'study_group_view.dart';

class StudyGroupPage extends StatelessWidget {
  const StudyGroupPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const StudyGroupPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = StudyGroupCubit(repository: context.read());
        unawaited(cubit.load());
        return cubit;
      },
      child: const StudyGroupView(),
    );
  }
}
