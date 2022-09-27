import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class ScheduleSettingsDrawer extends StatelessWidget {
  const ScheduleSettingsDrawer({Key? key, required this.builder})
      : super(key: key);

  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 16,
        top: MediaQuery.of(context).padding.top + 16,
        right: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: DarkThemeColors.background01,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Drawer(
        child: Container(
          color: DarkThemeColors.background01,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    left: 16, bottom: 24, top: 24, right: 16),
                child: Text("Настройки", style: DarkTextTheme.h5),
              ),
              Expanded(
                child: builder(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
