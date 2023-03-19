import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
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
        backgroundColor: AppTheme.colors.background01,
      ),
      backgroundColor: AppTheme.colors.background01,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<AnnouncesBloc, AnnouncesState>(
            builder: (context, state) {
          if (state is AnnouncesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AnnouncesLoaded) {
            return Padding(
              padding: const EdgeInsets.only(top: 24),
              child: ListView.separated(
                itemCount: state.announces.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    color: AppTheme.colors.background03,
                    elevation: 0,
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
                            style: AppTextStyle.bodyRegular
                                .copyWith(color: AppTheme.colors.deactive),
                          ),
                          const SizedBox(height: 8),
                          // Html(
                          //   data: state.announces[index].text,
                          //   style: {
                          //     "body": Style(
                          //       fontStyle: AppTextStyle.bodyRegular.fontStyle,
                          //       fontWeight: AppTextStyle.bodyRegular.fontWeight,
                          //       padding: const EdgeInsets.all(0),
                          //       margin: Margins.all(0),
                          //     ),
                          //   },
                          //   onLinkTap:
                          //       (String? url, context, attributes, element) {
                          //     if (url != null) {
                          //       launchUrlString(url);
                          //     }
                          //   },
                          // ),
                          HtmlWidget(
                            state.announces[index].text,
                            onLoadingBuilder:
                                (context, element, loadingProgress) =>
                                    const Center(
                              child: CircularProgressIndicator(),
                            ),
                            onTapUrl: (url) => launchUrlString(url),
                            renderMode: RenderMode.column,
                            textStyle: AppTextStyle.bodyRegular,
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
