import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rtu_mirea_app/presentation/bloc/announces_bloc/announces_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileAnnouncesPage extends StatelessWidget {
  const ProfileAnnouncesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Объявления"),
        backgroundColor: DarkThemeColors.background01,
      ),
      backgroundColor: DarkThemeColors.background01,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<AnnouncesBloc, AnnouncesState>(
            builder: (context, state) {
          if (state is AnnouncesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AnnouncesLoaded) {
            return Padding(
              padding: const EdgeInsets.only(top: 24),
              child: ListView.builder(
                itemCount: state.announces.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.announces[index].name,
                        style: DarkTextTheme.title,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        state.announces[index].date,
                        style: DarkTextTheme.bodyRegular
                            .copyWith(color: DarkThemeColors.deactive),
                      ),
                      const SizedBox(height: 8),
                      Html(
                        data: state.announces[index].text,
                        style: {
                          "body": Style(
                              fontStyle: DarkTextTheme.bodyRegular.fontStyle),
                        },
                        onLinkTap: (String? url, context, attributes, element) {
                          if (url != null) {
                            launch(url);
                          }
                        },
                      ),
                      const SizedBox(height: 13),
                      const Divider(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        }),
      ),
    );
  }
}
