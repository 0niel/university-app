import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/widgets/app_state_parsers.dart';
import 'package:stac_framework/stac_framework.dart';

Future<BuildContext> pumpKit(
  WidgetTester tester,
  StacParser<Map<String, dynamic>> parser,
  Map<String, dynamic> json, {
  MiniAppStateStore? store,
  bool dark = false,
}) async {
  late BuildContext captured;
  final content = Builder(
    builder: (context) {
      captured = context;
      return parser.parse(context, parser.getModel(json));
    },
  );
  final body = store == null
      ? content
      : MiniAppStateScope(
          store: store,
          child: ListenableBuilder(
            listenable: store,
            builder: (_, _) => content,
          ),
        );
  await tester.pumpWidget(
    MaterialApp(
      theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [body],
          ),
        ),
      ),
    ),
  );
  return captured;
}
