import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/ads/ads.dart';

class MeasuredStickyAd extends StatefulWidget {
  const MeasuredStickyAd({super.key, required this.onMeasured});

  final ValueChanged<double> onMeasured;

  @override
  State<MeasuredStickyAd> createState() => _MeasuredStickyAdState();
}

class _MeasuredStickyAdState extends State<MeasuredStickyAd> {
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _key.currentContext;
      if (context != null) {
        final size = context.size;
        if (size != null) {
          final totalHeight = size.height + StickyAd.padding.vertical * 2;
          widget.onMeasured(totalHeight);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: const StickyAd(),
    );
  }
}
