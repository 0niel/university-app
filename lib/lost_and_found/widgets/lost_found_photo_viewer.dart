import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LostFoundPhotoViewer extends StatelessWidget {
  const LostFoundPhotoViewer({required this.url, super.key});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: CachedNetworkImage(imageUrl: url, fit: .contain),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            right: 12,
            child: AppPressable(
              onTap: () => Navigator.of(context).pop(),
              semanticsButton: true,
              semanticsLabel: MaterialLocalizations.of(
                context,
              ).closeButtonTooltip,
              child: Container(
                width: NinjaMetrics.minTouchTarget,
                height: NinjaMetrics.minTouchTarget,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: const AppLineIconWidget(
                  AppLineIcon.close,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
