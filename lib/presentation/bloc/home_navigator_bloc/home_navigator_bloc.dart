import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/pages/schedule/schedule_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/settings/settings_screen.dart';

part 'home_navigator_event.dart';
part 'home_navigator_state.dart';

class HomeNavigatorBloc extends Bloc<HomeNavigatorEvent, HomeNavigatorState> {
  HomeNavigatorBloc() : super(SchedulePage());

  int selectedPageIndex = 0;

  @override
  Stream<HomeNavigatorState> mapEventToState(
    HomeNavigatorEvent event,
  ) async* {
    if (event is ChangeScreen) {
      if (selectedPageIndex != event.pageIndex) {
        selectedPageIndex = event.pageIndex;
        switch (event.routeName) {
          case ScheduleScreen.routeName:
            yield SchedulePage();
            break;
          case SettingsScreen.routeName:
            yield SettingsPage();
            break;
          default:
            break;
        }
      }
    }
  }
}
