import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/app/theme/app_color_schemes.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/deep_links.dart';
import 'package:rtu_mirea_app/navigation/tab_reselect_notifier.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/view/ninja_path_page.dart';
import 'package:rtu_mirea_app/profile/view/profile_settings_page.dart';
import 'package:rtu_mirea_app/profile/widgets/profile_progress_bar.dart';
import 'package:rtu_mirea_app/tour/tour.dart';
import 'package:user_repository/user_repository.dart';

part 'profile_account_entry.dart';
part 'profile_achievement_tile.dart';
part 'profile_achievement_tiles.dart';
part 'profile_achievements_empty.dart';
part 'profile_body.dart';
part 'profile_identity.dart';
part 'profile_metric.dart';
part 'profile_metrics.dart';
part 'profile_path_entry.dart';
part 'profile_section_error.dart';
part 'profile_section_label.dart';
part 'profile_skeleton.dart';
part 'profile_stats_row.dart';
part 'profile_streak_section.dart';
part 'profile_view.dart';
part 'profile_width.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select<AppBloc, User>((bloc) => bloc.state.user);
    final gamificationRepository = context.read<GamificationRepository>();
    final organizationId = context.read<UniversityConfig>().organizationId;
    return BlocProvider(
      create: (_) {
        final cubit = ProfileCubit(
          gamificationRepository: gamificationRepository,
          organizationId: organizationId,
          currentUser: user,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const _ProfileView(),
    );
  }
}

void _openNinjaPath(BuildContext context, {int initialTab = 0}) {
  final profileCubit = context.read<ProfileCubit>();
  unawaited(
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: profileCubit,
          child: NinjaPathPage(initialTab: initialTab),
        ),
      ),
    ),
  );
}

const kProfileNumberSeparator = '\u2009';

String profileNumber(int value) {
  final digits = value.abs().toString();
  final buffer = StringBuffer(value < 0 ? '-' : '');
  for (var i = 0; i < digits.length; i++) {
    if (i != 0 && (digits.length - i) % 3 == 0) {
      buffer.write(kProfileNumberSeparator);
    }
    buffer.write(digits[i]);
  }
  return buffer.toString();
}
