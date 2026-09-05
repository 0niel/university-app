import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';

class LostFoundPhotoViewer extends StatelessWidget {
  const LostFoundPhotoViewer({required this.url, super.key});

  final String url;

  @override
  Widget build(BuildContext context) => MediaViewerPage(
    items: [MediaItem(url: url, kind: .image)],
    initialIndex: 0,
  );
}
