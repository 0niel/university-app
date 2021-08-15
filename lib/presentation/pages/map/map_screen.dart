import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';


class MapScreen extends StatefulWidget {
  static const String routeName = '/map';

  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoView.customChild(
        child: SvgPicture.asset('assets/map/floor_0.svg'),
      ),
    );
  }
}
