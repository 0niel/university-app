import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class MapNavigationButton extends StatelessWidget {
  const MapNavigationButton({
    super.key,
    required this.floor,
    required this.onClick,
    required this.isSelected,
  });

  final int floor;
  final Function onClick;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 48, height: 48),
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          backgroundColor: WidgetStateProperty.all<Color>(
            isSelected ? AppTheme.colorsOf(context).background03 : AppTheme.colorsOf(context).background02,
          ),
          shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        child: Center(
          child: Text(
            floor.toString(),
            style: AppTextStyle.buttonS.copyWith(
              color: isSelected ? AppTheme.colorsOf(context).active : AppTheme.colorsOf(context).deactive,
            ),
          ),
        ),
        onPressed: () => onClick(),
      ),
    );
  }
}
