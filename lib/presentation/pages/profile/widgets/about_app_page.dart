import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/about_app_bloc/about_app_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

import 'member_info.dart';

class AboutAppPage extends StatelessWidget {
  static const String routeName = '/profile/about_app';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'О приложении',
          style: DarkTextTheme.title,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Open Source', style: DarkTextTheme.h4),
            SizedBox(height: 8),
            Text(
              'Это приложение и все относящиеся к нему сервисы являются 100% бесплатными и Open Source продуктами. Мы с огромным удовольствием примем любые ваши предложения и сообщения, а также мы рады любому вашему участию в проекте!',
              style: DarkTextTheme.bodyRegular,
            ),
            SizedBox(height: 24),
            Text('Разработчики', style: DarkTextTheme.h4),
            SizedBox(height: 16),
            BlocBuilder<AboutAppBloc, AboutAppState>(
              buildWhen: (prevState, currentState) {
                if (prevState is AboutAppMembersLoadError) {
                  if (prevState.contributorsLoadError) return false;
                }
                return true;
              },
              builder: (context, state) {
                if (state is AboutAppMembersLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: DarkThemeColors.primary,
                      strokeWidth: 5,
                    ),
                  );
                } else if (state is AboutAppMembersLoaded) {
                  print('true');
                  return Wrap(
                    spacing: 16.0,
                    runSpacing: 8.0,
                    children: List.generate(state.contributors.length, (index) {
                      return MemberInfo(
                        username: state.contributors[index].login,
                        avatarUrl: state.contributors[index].avatarUrl,
                        profileUrl: state.contributors[index].htmlUrl,
                      );
                    }),
                  );
                } else if (state is AboutAppMembersLoadError) {
                  return Center(
                    child: Text(
                      'Произошла ошибка при загрузке разработчиков. Проверьте ваше интернет-соединение.',
                      style: DarkTextTheme.title,
                    ),
                  );
                }
                return Container();
              },
            ),
            SizedBox(height: 24),
            Text('Патроны', style: DarkTextTheme.h4),
            SizedBox(height: 16),
            BlocBuilder<AboutAppBloc, AboutAppState>(
              buildWhen: (prevState, currentState) {
                if (prevState is AboutAppMembersLoadError) {
                  if (prevState.patronsLoadError) return false;
                }
                return true;
              },
              builder: (context, state) {
                if (state is AboutAppMembersLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: DarkThemeColors.primary,
                      strokeWidth: 5,
                    ),
                  );
                } else if (state is AboutAppMembersLoaded) {
                  return Wrap(
                    spacing: 16.0,
                    runSpacing: 8.0,
                    children: List.generate(state.patrons.length, (index) {
                      return MemberInfo(
                        username: state.patrons[index].username,
                        avatarUrl: 'https://mirea.ninja/' +
                            state.patrons[index].avatarTemplate
                                .replaceAll('{size}', '120'),
                        profileUrl: 'https://mirea.ninja/u/' +
                            state.patrons[index].username,
                      );
                    }),
                  );
                } else if (state is AboutAppMembersLoadError) {
                  return Center(
                    child: Text(
                      'Произошла ошибка при загрузке патронов.',
                      style: DarkTextTheme.title,
                    ),
                  );
                }
                return Container();
              },
            )
          ]),
        ),
      ),
    );
  }
}
