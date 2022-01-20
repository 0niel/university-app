import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/pages/map/map_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/news/news_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/schedule/schedule_screen.dart';

part 'home_navigator_event.dart';
part 'home_navigator_state.dart';

class HomeNavigatorBloc extends Bloc<HomeNavigatorEvent, HomeNavigatorState> {
  HomeNavigatorBloc() : super(SchedulePage()) {
    on<ChangeScreen>(_onChangeScreen);
  }

  int selectedPageIndex = 1;

  void _onChangeScreen(
      ChangeScreen event, Emitter<HomeNavigatorState> emit) async {
    if (selectedPageIndex != event.pageIndex) {
      selectedPageIndex = event.pageIndex;
      switch (event.routeName) {
        case ScheduleScreen.routeName:
          emit(SchedulePage());
          break;
        case ProfileScreen.routeName:
          emit(ProfilePage());
          break;
        case MapScreen.routeName:
          emit(MapPage());
          break;
        case NewsScreen.routeName:
          emit(NewsPage());
          break;
        default:
          break;
      }
    }
  }
}
