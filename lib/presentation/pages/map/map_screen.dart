import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = '/map';

  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
    return PhotoView.customChild(
      child: SvgPicture.asset('assets/map/floor_0.svg'),
    );
  }

  Widget navigation() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        getNavigationButton(Icons.arrow_upward_outlined),
        Container(height: 10),
        getNavigationButton(Icons.arrow_downward_outlined),
      ],
    );
  }

  Widget getNavigationButton(IconData iconData){
    return IconButton(
      onPressed: () {},
      icon: Container(
        child: Icon(
          iconData,
          color: DarkThemeColors.white,
        ),
        decoration: BoxDecoration(
          border:
          Border.all(color: DarkThemeColors.background02, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(2),),),
      ),
    );
  }
}
