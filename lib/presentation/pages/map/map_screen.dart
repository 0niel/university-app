import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rtu_mirea_app/presentation/bloc/map_cubit/map_cubit.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

import 'widgets/map_navigation_button.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = '/map';

  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final floors = [
    SvgPicture.asset('assets/map/floor_0.svg'),
    SvgPicture.asset('assets/map/floor_1.svg'),
    SvgPicture.asset('assets/map/floor_2.svg'),
    SvgPicture.asset('assets/map/floor_3.svg'),
    SvgPicture.asset('assets/map/floor_4.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: DarkThemeColors.background01,
          ),
          _buildMap(),
          _buildSearchBar(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 10, bottom: 16),
              child: _buildNavigation(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return FloatingSearchBar(
      accentColor: DarkThemeColors.primary,
      iconColor: DarkThemeColors.white,
      backgroundColor: DarkThemeColors.background02,
      hint: 'Что будем искать, Милорд?',
      hintStyle: DarkTextTheme.titleS.copyWith(color: DarkThemeColors.deactive),
      borderRadius: BorderRadius.all(Radius.circular(12)),
      builder: (context, transition) {
        return Container();
      },
    );
  }

  Widget _buildMap() {
    return BlocBuilder<MapCubit, int>(
      builder: (context, state) => PhotoView.customChild(
        initialScale: 2.0,
        child: floors[state],
        backgroundDecoration:
            BoxDecoration(color: DarkThemeColors.background01),
      ),
    );
  }

  Widget _buildNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: DarkThemeColors.background02,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          MapNavigationButton(
              floor: 4, onClick: () => context.read<MapCubit>().goToFloor(4)),
          MapNavigationButton(
              floor: 3, onClick: () => context.read<MapCubit>().goToFloor(3)),
          MapNavigationButton(
              floor: 2, onClick: () => context.read<MapCubit>().goToFloor(2)),
          MapNavigationButton(
              floor: 1, onClick: () => context.read<MapCubit>().goToFloor(1)),
          MapNavigationButton(
              floor: 0, onClick: () => context.read<MapCubit>().goToFloor(0)),
        ],
      ),
    );
  }
}
