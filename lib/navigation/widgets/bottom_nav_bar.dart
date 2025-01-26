import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:app_ui/app_ui.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key, required this.index, required this.onClick});

  final Function(int) onClick;
  final int index;

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DotNavigationBar(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      currentIndex: widget.index,
      onTap: (index) {
        HapticFeedback.lightImpact();
        setState(() {
          selectedIndex = index;
        });
        widget.onClick(index);
      },
      dotIndicatorColor: AppColors.dark.primary,
      backgroundColor: Theme.of(context).extension<AppColors>()!.background03,
      borderRadius: 18,
      enablePaddingAnimation: false,
      marginR: const EdgeInsets.only(left: 24, right: 24),
      paddingR: const EdgeInsets.only(bottom: 5, top: 7),
      splashBorderRadius: 50,
      items: [
        _buildNavBarItem(
            0,
            Assets.icons.hugeicons.news.svg(
              color: Theme.of(context).extension<AppColors>()!.active,
            )),
        _buildNavBarItem(
            1,
            Assets.icons.hugeicons.calendar03.svg(
              color: Theme.of(context).extension<AppColors>()!.active,
            )),
        _buildNavBarItem(
            2,
            Assets.icons.hugeicons.dashboardSquare01.svg(
              color: Theme.of(context).extension<AppColors>()!.active,
            )),
        _buildNavBarItem(
            3,
            Assets.icons.hugeicons.userAccount.svg(
              color: Theme.of(context).extension<AppColors>()!.active,
            )),
      ],
    );
  }

  DotNavigationBarItem _buildNavBarItem(int index, Widget icon) {
    bool isSelected = index == selectedIndex;

    return DotNavigationBarItem(
      icon: isSelected
          ? icon
              .animate()
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.03, 1.03),
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
              )
              .moveY(
                begin: 0,
                end: -2,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
              )
              .then()
              .scale(
                begin: const Offset(1.03, 1.03),
                end: const Offset(1.0, 1.0),
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
              )
              .moveY(
                begin: -2,
                end: 0,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
              )
          : icon,
      selectedColor: AppColors.dark.primary,
    );
  }
}
