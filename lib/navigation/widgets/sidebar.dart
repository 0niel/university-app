import 'dart:math';

import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key, required this.currentIndex, required this.onClick});
  final int currentIndex;
  final ValueSetter<int> onClick;

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  final double collapsedWidth = 90;
  final double expandedWidth = 270;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn);
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.4, 1.0, curve: Curves.easeInOut)));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    HapticFeedback.mediumImpact();
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Calculate width based on animation value for smoother effect
        final width = collapsedWidth + (_animation.value * (expandedWidth - collapsedWidth));

        return Container(
          width: width,
          height: double.infinity,
          margin: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Material(
              color: colors.background02,
              child: Stack(
                children: [
                  // Background decorative elements
                  Positioned(
                    top: -30,
                    right: -30,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [colors.primary.withOpacity(0.07), Colors.transparent]),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: -60,
                    left: -60,
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [colors.colorful02.withOpacity(0.07), Colors.transparent]),
                      ),
                    ),
                  ),

                  // Main content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(colors),

                      const SizedBox(height: 24),

                      // Navigation items
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Main navigation
                              Padding(
                                padding: const EdgeInsets.only(left: 16, bottom: 12),
                                child: _buildSectionTitle('Навигация', colors),
                              ),

                              _buildNavigationItem(
                                icon: Assets.icons.hugeicons.news.svg(
                                  color: widget.currentIndex == 0 ? colors.colorful03 : colors.active.withOpacity(0.8),
                                ),
                                title: 'Новости',
                                index: 0,
                                accentColor: colors.colorful03,
                                colors: colors,
                              ),

                              _buildNavigationItem(
                                icon: Assets.icons.hugeicons.calendar03.svg(
                                  color: widget.currentIndex == 1 ? colors.colorful01 : colors.active.withOpacity(0.8),
                                ),
                                title: 'Расписание',
                                index: 1,
                                accentColor: colors.colorful01,
                                colors: colors,
                              ),

                              _buildNavigationItem(
                                icon: Assets.icons.hugeicons.dashboardSquare01.svg(
                                  color: widget.currentIndex == 2 ? colors.colorful02 : colors.active.withOpacity(0.8),
                                ),
                                title: 'Сервисы',
                                index: 2,
                                accentColor: colors.colorful02,
                                colors: colors,
                              ),

                              _buildNavigationItem(
                                icon: Assets.icons.hugeicons.userAccount.svg(
                                  color: widget.currentIndex == 3 ? colors.primary : colors.active.withOpacity(0.8),
                                ),
                                title: 'Профиль',
                                index: 3,
                                accentColor: colors.primary,
                                colors: colors,
                              ),

                              // Extra space for larger screens
                              const SizedBox(height: 32),

                              // Extra section
                              if (_animation.value > 0.7)
                                FadeTransition(
                                  opacity: _textFadeAnimation,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16, bottom: 12),
                                        child: _buildSectionTitle('Приложение', colors),
                                      ),
                                      _buildSettingsItem(
                                        icon: Icon(
                                          Icons.info_outline_rounded,
                                          color: colors.active.withOpacity(0.8),
                                          size: 20,
                                        ),
                                        title: 'О приложении',
                                        colors: colors,
                                        onTap: () {},
                                      ),
                                      _buildSettingsItem(
                                        icon: Icon(
                                          Icons.settings_outlined,
                                          color: colors.active.withOpacity(0.8),
                                          size: 20,
                                        ),
                                        title: 'Настройки',
                                        colors: colors,
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      // Toggle expand/collapse button
                      _buildToggleButton(colors),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(AppColors colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.background03.withOpacity(0.3), width: 1)),
      ),
      child: Row(
        children: [
          // App logo with animation
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: colors.primary.withOpacity(0.1), blurRadius: 10, spreadRadius: 0)],
            ),
            child: Center(
              child: Icon(Icons.school_rounded, size: 24, color: colors.primary)
                  .animate(onPlay: (controller) => controller.repeat(period: const Duration(seconds: 3)))
                  .custom(
                    duration: const Duration(seconds: 2),
                    builder: (context, value, child) {
                      return Transform.scale(scale: 1.0 + (0.05 * (0.5 - 0.5 * cos(value * 6.28))), child: child);
                    },
                  ),
            ),
          ),

          if (_animation.value > 0.5) ...[
            const SizedBox(width: 16),
            // Title with fade in animation
            FadeTransition(
              opacity: _textFadeAnimation,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(_animation),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "РТУ МИРЭА",
                      style: AppTextStyle.titleM.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.active,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text("Университет", style: AppTextStyle.captionL.copyWith(color: colors.deactive)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppColors colors) {
    return AnimatedOpacity(
      opacity: _animation.value > 0.5 ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyle.captionL.copyWith(color: colors.deactive, fontWeight: FontWeight.w600, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildNavigationItem({
    required Widget icon,
    required String title,
    required int index,
    required Color accentColor,
    required AppColors colors,
  }) {
    final isSelected = widget.currentIndex == index;
    final bool expanded = _animation.value > 0.5;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            widget.onClick(index);
          },
          splashColor: accentColor.withOpacity(0.1),
          highlightColor: accentColor.withOpacity(0.05),
          hoverColor: colors.background03.withOpacity(0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: expanded ? 16 : 0),
            decoration:
                isSelected
                    ? BoxDecoration(
                      color: accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: accentColor.withOpacity(0.3), width: 1.5),
                      boxShadow: [BoxShadow(color: accentColor.withOpacity(0.06), blurRadius: 8, spreadRadius: 1)],
                    )
                    : null,
            child: Row(
              mainAxisAlignment: expanded ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isSelected ? accentColor.withOpacity(0.15) : colors.background03.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child:
                          isSelected
                              ? icon
                                  .animate(
                                    onPlay: (controller) => controller.repeat(period: const Duration(seconds: 10)),
                                  )
                                  .custom(
                                    duration: const Duration(seconds: 3),
                                    builder: (context, value, child) {
                                      return Transform.rotate(angle: sin(value * 6.28) * 0.05, child: child);
                                    },
                                  )
                              : icon,
                    ),
                  ),
                ),

                // Show text only when expanded
                if (expanded) ...[
                  const SizedBox(width: 12),
                  FadeTransition(
                    opacity: _textFadeAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero).animate(_animation),
                      child: Text(
                        title,
                        style: AppTextStyle.body.copyWith(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? accentColor : colors.active,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Indicator for selected item
                  if (isSelected)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor,
                        boxShadow: [BoxShadow(color: accentColor.withOpacity(0.4), blurRadius: 4, spreadRadius: 1)],
                      ),
                    ).animate().scaleXY(
                      begin: 0.5,
                      end: 1.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.elasticOut,
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required Widget icon,
    required String title,
    required AppColors colors,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: colors.background03.withOpacity(0.2),
          highlightColor: colors.background03.withOpacity(0.1),
          hoverColor: colors.background03.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: colors.background03.withOpacity(0.2), shape: BoxShape.circle),
                  child: Center(child: icon),
                ),
                const SizedBox(width: 12),
                Text(title, style: AppTextStyle.body.copyWith(fontWeight: FontWeight.w500, color: colors.active)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _toggleExpanded,
          splashColor: colors.primary.withOpacity(0.1),
          hoverColor: colors.background03.withOpacity(0.1),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: colors.background03.withOpacity(0.5), width: 1.5),
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colors.background03.withOpacity(0.05), colors.background03.withOpacity(0.15)],
              ),
            ),
            child: Row(
              mainAxisAlignment: _animation.value > 0.5 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
              children: [
                if (_animation.value > 0.5)
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: FadeTransition(
                      opacity: _textFadeAnimation,
                      child: Text(
                        isExpanded ? "Свернуть" : "Развернуть",
                        style: AppTextStyle.captionL.copyWith(fontWeight: FontWeight.w500, color: colors.active),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _animation.value > 0.5 ? 16.0 : 0),
                  child: AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(Icons.keyboard_arrow_right_rounded, color: colors.active, size: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
