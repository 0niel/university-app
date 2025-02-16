import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({
    super.key,
    required this.currentIndex,
    required this.onClick,
  });
  final int currentIndex;
  final ValueSetter<int> onClick;

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  final double collapsedWidth = 60;
  final double expandedWidth = 156;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).extension<AppColors>()!.background01.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          color: Theme.of(context).extension<AppColors>()!.background02,
        ),
        duration: const Duration(milliseconds: 300),
        width: isExpanded ? expandedWidth : collapsedWidth,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                alignment: Alignment.center,
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).extension<AppColors>()!.background03,
                ),
                icon: Icon(
                  isExpanded ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                  color: Theme.of(context).extension<AppColors>()!.active,
                ),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView(
                  children: [
                    SidebarNavButton(
                      isExpanded: isExpanded,
                      isSelected: widget.currentIndex == 0,
                      title: "Новости",
                      icon: Assets.icons.hugeicons.news.svg(
                        color: Theme.of(context).extension<AppColors>()!.active,
                      ),
                      onClick: () => widget.onClick(0),
                    ),
                    SidebarNavButton(
                      isExpanded: isExpanded,
                      isSelected: widget.currentIndex == 1,
                      title: "Расписание",
                      icon: Assets.icons.hugeicons.calendar03.svg(
                        color: Theme.of(context).extension<AppColors>()!.active,
                      ),
                      onClick: () => widget.onClick(1),
                    ),
                    SidebarNavButton(
                      isExpanded: isExpanded,
                      isSelected: widget.currentIndex == 2,
                      title: "Сервисы",
                      icon: Assets.icons.hugeicons.dashboardSquare01.svg(
                        color: Theme.of(context).extension<AppColors>()!.active,
                      ),
                      onClick: () => widget.onClick(2),
                    ),
                    SidebarNavButton(
                      isExpanded: isExpanded,
                      isSelected: widget.currentIndex == 3,
                      title: "Профиль",
                      icon: Assets.icons.hugeicons.userAccount.svg(
                        color: Theme.of(context).extension<AppColors>()!.active,
                      ),
                      onClick: () => widget.onClick(3),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SidebarNavButton extends StatelessWidget {
  const SidebarNavButton({
    super.key,
    required this.isExpanded,
    required this.isSelected,
    required this.title,
    required this.icon,
    required this.onClick,
  });
  final bool isExpanded;
  final bool isSelected;
  final String title;
  final Widget icon;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: isSelected
          ? BoxDecoration(
              color: Theme.of(context).extension<AppColors>()!.colorful03,
              borderRadius: BorderRadius.circular(16),
            )
          : null,
      child: TextButton(
        onPressed: onClick,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(8),
          foregroundColor: isSelected
              ? Theme.of(context).extension<AppColors>()!.background01
              : Theme.of(context).extension<AppColors>()!.active,
        ),
        child: Row(
          mainAxisAlignment: isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            icon,
            if (isExpanded) ...[
              const SizedBox(width: 16),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    title,
                    key: ValueKey(title),
                    style: AppTextStyle.buttonS.copyWith(
                      color: Theme.of(context).extension<AppColors>()!.active,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
