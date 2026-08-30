import 'dart:async';

import 'package:app_ui/app_ui.dart'
    show AppIconButton, AppSpacing, AppText, ThemeDataColorsX;
import 'package:flutter/material.dart';

class SlideshowNavigation extends StatefulWidget {
  const SlideshowNavigation({
    required this.totalPages,
    required this.controller,
    required this.navigationLabel,
    super.key,
  });

  final int totalPages;
  final PageController controller;
  final String navigationLabel;

  @override
  State<SlideshowNavigation> createState() => _SlideshowNavigationState();
}

class _SlideshowNavigationState extends State<SlideshowNavigation> {
  static const _pageAnimationDuration = Duration(milliseconds: 300);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPageChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final navigationBarLabel =
        '${_currentPage + 1} ${widget.navigationLabel} ${widget.totalPages}';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavigationButton(
            context: context,
            key: const Key('slideshow_slideshowButtonsLeft'),
            icon: Icons.arrow_back_ios,
            foregroundColor:
                _currentPage > 0
                    ? colors.active
                    : colors.onSurface.withValues(alpha: 0.3),
            onPressed:
                _currentPage > 0
                    ? () => unawaited(
                      widget.controller.previousPage(
                        duration: _pageAnimationDuration,
                        curve: Curves.easeInOut,
                      ),
                    )
                    : null,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: colors.background02.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              navigationBarLabel,
              style: AppText.body.copyWith(
                color: colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildNavigationButton(
            context: context,
            key: const Key('slideshow_slideshowButtonsRight'),
            icon: Icons.arrow_forward_ios,
            foregroundColor:
                _currentPage < widget.totalPages - 1
                    ? colors.active
                    : colors.onSurface.withValues(alpha: 0.3),
            onPressed:
                _currentPage < widget.totalPages - 1
                    ? () => unawaited(
                      widget.controller.nextPage(
                        duration: _pageAnimationDuration,
                        curve: Curves.easeInOut,
                      ),
                    )
                    : null,
          ),
        ],
      ),
    );
  }

  void _onPageChanged() {
    final currentPage = widget.controller.page?.toInt() ?? 0;
    if (currentPage != _currentPage && mounted) {
      setState(() => _currentPage = currentPage);
    }
  }

  Widget _buildNavigationButton({
    required BuildContext context,
    required Key key,
    required IconData icon,
    required Color foregroundColor,
    required VoidCallback? onPressed,
  }) {
    final colors = Theme.of(context).colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.background02.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AppIconButton(
        key: key,
        onPressed: onPressed,
        icon: Icon(icon),
        foregroundColor: foregroundColor,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
