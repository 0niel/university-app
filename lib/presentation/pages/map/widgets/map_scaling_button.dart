import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rtu_mirea_app/presentation/bloc/map_cubit/map_cubit.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';

class MapScalingButton extends StatelessWidget {
  const MapScalingButton(
      {Key? key,
      required this.onClick,
      required this.maxScale,
      required this.minScale,
      required this.defaultScale,
      required this.controller})
      : super(key: key);

  final double defaultScale;
  final double minScale;
  final double maxScale;

  final PhotoViewController controller;
  final Function onClick;

  int _calculateScalePercentage() {
    return (((controller.scale ?? defaultScale) - minScale) *
            200 /
            (maxScale - minScale))
        .round();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) => ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: 64, height: 48),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  DarkThemeColors.background02),
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ))),
          child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(_calculateScalePercentage().toString() + "%")),
          onPressed: () => onClick(),
        ),
      ),
    );
  }
}
