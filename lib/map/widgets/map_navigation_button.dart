import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

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
            isSelected
                ? Theme.of(context).extension<AppColors>()!.background03
                : Theme.of(context).extension<AppColors>()!.background02,
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
              color: isSelected
                  ? Theme.of(context).extension<AppColors>()!.active
                  : Theme.of(context).extension<AppColors>()!.deactive,
            ),
          ),
        ),
        onPressed: () => onClick(),
      ),
    );
  }
}
