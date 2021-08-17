import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rtu_mirea_app/presentation/bloc/map_cubit/map_cubit.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';

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
          map(),
          searchBar(),
          Align(
            alignment: Alignment.centerRight,
            child: navigation(),
          ),
        ],
      ),
    );
  }

  Widget searchBar() {
    return FloatingSearchBar(
      accentColor: DarkThemeColors.primary,
      iconColor: DarkThemeColors.white,
      backgroundColor: DarkThemeColors.background02,
      hint: 'Что будем искать, Милорд?',
      hintStyle: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: DarkThemeColors.deactive,
      ),
      borderRadius: BorderRadius.all(Radius.circular(12)),
      builder: (context, transition) {
        return Container();
      },
    );
  }

  Widget map() {
    return BlocBuilder<MapCubit, int>(
      builder: (context, state) => PhotoView.customChild(child: floors[state]),
    );
  }

  Widget navigation() {
    MapCubit cubit = BlocProvider.of<MapCubit>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        getNavigationButton(Icons.arrow_upward_outlined, cubit.goUp),
        getNavigationButton(Icons.arrow_downward_outlined, cubit.goDown),
      ],
    );
  }

  Widget getNavigationButton(IconData iconData, Function onPressed) {
    return IconButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        onPressed();
      },
      icon: Container(
        child: Icon(
          iconData,
          size: 35,
          color: DarkThemeColors.white,
        ),
        decoration: BoxDecoration(
          color: DarkThemeColors.background02,
          //border: Border.all(color: DarkThemeColors.background02, width: 2),
          borderRadius: BorderRadius.all(
            Radius.circular(2),
          ),
        ),
      ),
    );
  }
}
