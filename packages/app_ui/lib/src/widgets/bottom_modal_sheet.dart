import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class BottomModalSheet extends StatelessWidget {
  const BottomModalSheet({
    required this.title,
    required this.child,
    super.key,
    this.onConfirm,
    this.description,
    this.isExpandable = true,
  });

  final VoidCallback? onConfirm;
  final String title;
  final String? description;
  final Widget child;
  final bool isExpandable;

  static Future<void> show(
    BuildContext context, {
    required Widget child,
    required String title,
    String? description,
    bool isExpandable = false,
    Color? backgroundColor,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {},
                    child: BottomModalSheet(
                      title: title,
                      description: description,
                      isExpandable: isExpandable,
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _DraggableModalSheet(
      title: title,
      description: description,
      isExpandable: isExpandable,
      child: child,
    );
  }
}

class _DraggableModalSheet extends StatefulWidget {
  const _DraggableModalSheet({
    required this.title,
    required this.child,
    required this.isExpandable,
    this.description,
  });

  final String title;
  final String? description;
  final Widget child;
  final bool isExpandable;

  @override
  State<_DraggableModalSheet> createState() => _DraggableModalSheetState();
}

class _DraggableModalSheetState extends State<_DraggableModalSheet> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dragStartPosition = 0;
  double _sheetHeightFactor = 0.75;
  final bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 0.75, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.75;

    return GestureDetector(
      onVerticalDragStart: (details) {
        _dragStartPosition = details.localPosition.dy;
      },
      onVerticalDragUpdate: (details) {
        final dragOffset = _dragStartPosition - details.localPosition.dy;

        if (dragOffset > 0 && widget.isExpandable) {
          setState(() {
            _sheetHeightFactor = (_sheetHeightFactor + dragOffset / screenHeight).clamp(0.75, 1.0);
          });
        } else if (dragOffset < 0) {
          setState(() {
            _sheetHeightFactor = (_sheetHeightFactor + dragOffset / screenHeight).clamp(0.33, 0.75);
          });
        }
      },
      onVerticalDragEnd: (details) {
        if (_sheetHeightFactor > 0.85) {
          _expandModal();
        } else if (_sheetHeightFactor < 0.6) {
          Navigator.of(context).pop();
        } else {
          _shrinkModal();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            margin: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 12,
              bottom: bottomPadding + 20,
            ),
            constraints: BoxConstraints(
              minHeight: screenHeight * 0.33,
              maxHeight: maxHeight,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).extension<AppColors>()!.background02,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: bottomPadding + 16,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 6,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).extension<AppColors>()!.deactive,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  Center(
                    child: Text(
                      widget.title,
                      style: AppTextStyle.h5.copyWith(
                        color: Theme.of(context).extension<AppColors>()!.active,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.description != null)
                    Text(
                      widget.description!,
                      style: AppTextStyle.captionL.copyWith(
                        color: Theme.of(context).extension<AppColors>()!.deactive,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 32),
                  widget.child,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _expandModal() {
    setState(() {
      _sheetHeightFactor = 1.0;
    });
  }

  void _shrinkModal() {
    setState(() {
      _sheetHeightFactor = 0.75;
    });
  }
}
