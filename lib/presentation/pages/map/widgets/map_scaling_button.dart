import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rtu_mirea_app/presentation/bloc/map_cubit/map_cubit.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';

class MapScalingButton extends StatelessWidget {
  const MapScalingButton(
      { Key? key,
        required this.onClick,
        required this.maxScale,
        required this.minScale,
        required this.controller})
      : super(key: key);

  final double minScale;
  final double maxScale;

  final PhotoViewController controller;
  final Function onClick;

  int _calculateScalePercentage() {
    var result = (((controller.scale ?? maxScale - minScale) * 100 / (maxScale - minScale)) - 5).round();
    if (result <= 0) return 0;
    if (result >= 100) return 100;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) => ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: 64, height: 48),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(DarkThemeColors.background02),
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ))),
          child: FittedBox(
              fit: BoxFit.fitWidth,
              child:Text(_calculateScalePercentage().toString() + "%")
          ),
          onPressed: () => onClick(),
        ),
      ),
    );
  }
}