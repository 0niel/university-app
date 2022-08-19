import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/map_cubit/map_cubit.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';

class MapNavigationButton extends StatelessWidget {
  const MapNavigationButton(
      {Key? key, required this.floor, required this.onClick})
      : super(key: key);

  final int floor;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      buildWhen: (prevState, currentState) =>
          prevState.floor != currentState.floor,
      builder: (context, state) => ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                state.floor == floor
                    ? DarkThemeColors.background03
                    : DarkThemeColors.background02,
              ),
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ))),
          child: Text(floor.toString()),
          onPressed: () => onClick(),
        ),
      ),
    );
  }
}
