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
              builder: (context, state) {
                if (state is AboutAppContributorsLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: DarkThemeColors.primary,
                      strokeWidth: 5,
                    ),
                  );
                } else if (state is AboutAppContributorsLoaded) {
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 100,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: state.contributors.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
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
                          ],
                        );
                      },
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
