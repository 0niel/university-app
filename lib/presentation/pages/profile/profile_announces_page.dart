import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_svg/flutter_html_svg.dart';
import 'package:flutter_html_video/flutter_html_video.dart';
import 'package:rtu_mirea_app/presentation/bloc/announces_bloc/announces_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class ProfileAnnouncesPage extends StatelessWidget {
  const ProfileAnnouncesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Объявления"),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<AnnouncesBloc, AnnouncesState>(builder: (context, state) {
          if (state is AnnouncesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AnnouncesLoaded) {
            return Padding(
              padding: const EdgeInsets.only(top: 24),
              child: ListView.separated(
                itemCount: state.announces.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.announces[index].name,
                            style: AppTextStyle.title,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            state.announces[index].date,
                            style: AppTextStyle.bodyRegular.copyWith(color: AppTheme.colors.deactive),
                          ),
                          const SizedBox(height: 8),
                          Html(
                            data: state.announces[index].text,
                            style: {
                              "body": Style(
                                fontStyle: AppTextStyle.bodyRegular.fontStyle,
                                fontWeight: AppTextStyle.bodyRegular.fontWeight,
                                padding: HtmlPaddings.all(0),
                                margin: Margins.all(0),
                              ),
                            },
                            onLinkTap: (String? url, Map<String, String> attributes, _) {
                              if (url != null) {
                                launchUrlString(url);
                              }
                            },
                            extensions: const [
                              VideoHtmlExtension(),
                              SvgHtmlExtension(),
                            ],
                          ),
                        ],
                      ),
                    ),
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
