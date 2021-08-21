import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/about_app_bloc/about_app_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class AboutAppPage extends StatelessWidget {
  static const String routeName = '/profile/about_app';

  @override
  Widget build(BuildContext context) {
    context.read<AboutAppBloc>().add(AboutAppGetContributors());
    context.read<AboutAppBloc>().add(AboutAppGetPatrons());
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
                return currentState is AboutAppContributorsLoading ||
                    currentState is AboutAppContributorsLoaded ||
                    currentState is AboutAppContributorsLoadError;
              },
              builder: (context, state) {
                if (state is AboutAppContributorsLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: DarkThemeColors.primary,
                      strokeWidth: 5,
                    ),
                  );
                } else if (state is AboutAppContributorsLoaded) {
                  return Wrap(
                    spacing: 16.0,
                    runSpacing: 8.0,
                    children: List.generate(state.contributors.length, (index) {
                      return Column(children: [
                        CachedNetworkImage(
                          imageUrl: state.contributors[index].avatarUrl,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            radius: 30,
                            backgroundImage: imageProvider,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          state.contributors[index].login,
                          style: DarkTextTheme.bodyBold,
                        ),
                      ]);
                    }),
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
                return currentState is AboutAppPatronsLoading ||
                    currentState is AboutAppPatronsLoaded ||
                    currentState is AboutAppPatronsLoadError;
              },
              builder: (context, state) {
                if (state is AboutAppPatronsLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: DarkThemeColors.primary,
                      strokeWidth: 5,
                    ),
                  );
                } else if (state is AboutAppPatronsLoaded) {
                  return Wrap(
                    spacing: 16.0,
                    runSpacing: 8.0,
                    children: List.generate(state.patrons.length, (index) {
                      return Column(children: [
                        CachedNetworkImage(
                          imageUrl: 'https://mirea.ninja/' +
                              state.patrons[index].avatarTemplate
                                  .replaceAll('{size}', '120'),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            radius: 30,
                            backgroundImage: imageProvider,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          state.patrons[index].username,
                          style: DarkTextTheme.bodyBold,
                        ),
                      ]);
                    }),
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
