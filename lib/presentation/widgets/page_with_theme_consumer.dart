import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rtu_mirea_app/presentation/app_notifier.dart';

abstract class PageWithThemeConsumer extends StatelessWidget {
  const PageWithThemeConsumer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (context, appNotifier, child) {
        return buildPage(context);
      },
    );
  }

  Widget buildPage(BuildContext context);
}
