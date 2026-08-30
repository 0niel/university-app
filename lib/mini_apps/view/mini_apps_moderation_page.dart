import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_apps_moderation_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/widgets.dart';

part 'mini_apps_moderation_view.dart';
part 'moderation_body.dart';
part 'moderation_section_label.dart';
part 'moderation_skeleton.dart';
part 'pending_card_skeleton.dart';
part 'notes_sheet.dart';
part 'pending_card.dart';
part 'reported_card.dart';

class MiniAppsModerationPage extends StatelessWidget {
  const MiniAppsModerationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = MiniAppsModerationCubit(
          miniAppsRepository: context.read(),
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const MiniAppsModerationView(),
    );
  }
}
