import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/app/theme/app_color_schemes.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_list_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/navigation/tab_reselect_notifier.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_extras_cubit.dart';
import 'package:rtu_mirea_app/profile/utils/supported_quest.dart';
import 'package:rtu_mirea_app/profile/view/ninja_path_page.dart';
import 'package:rtu_mirea_app/profile/widgets/edit_profile_sheet.dart';
import 'package:rtu_mirea_app/profile/widgets/guest_upgrade_sheet.dart';
import 'package:rtu_mirea_app/profile/widgets/leaderboard_sheet.dart';
import 'package:rtu_mirea_app/profile/widgets/profile/profile_widgets.dart';
import 'package:rtu_mirea_app/profile/widgets/profile_activity_card.dart';
import 'package:rtu_mirea_app/profile/widgets/rows/settings_rows.dart';
import 'package:rtu_mirea_app/tour/tour.dart';
import 'package:user_repository/user_repository.dart';

part 'profile_content.dart';
part 'profile_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select<AppBloc, User>((bloc) => bloc.state.user);
    final gamificationRepository = context.read<GamificationRepository>();
    final organizationId = context.read<UniversityConfig>().organizationId;
    return MultiBlocProvider(
      key: ValueKey((user.id, user.isGuest, user.email)),
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = ProfileCubit(
              gamificationRepository: gamificationRepository,
              organizationId: organizationId,
              currentUser: user,
            );
            unawaited(cubit.load());
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final cubit = FriendsListCubit(friendsRepository: context.read());
            unawaited(cubit.load());
            return cubit;
          },
        ),
        BlocProvider(create: (_) => ProfileExtrasCubit(userId: user.id)),
      ],
      child: const ProfileView(),
    );
  }
}

void openNinjaPath(BuildContext context, {int initialTab = 0}) {
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
