import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/map_cubit/map_cubit.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

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
                    ? AppTheme.colors.background03
                    : AppTheme.colors.background02,
              ),
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ))),
          child: Text(
            floor.toString(),
            style: AppTextStyle.buttonS.copyWith(
              color: state.floor == floor
                  ? AppTheme.colors.active
                  : AppTheme.colors.active.withOpacity(0.5),
            ),
          ),
          onPressed: () => onClick(),
        ),
      ),
    );
  }
}
