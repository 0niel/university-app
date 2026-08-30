import 'package:rtu_mirea_app/map/models/models.dart';

class SvgInteractiveMapController {
  SvgInteractiveMapHandle? _handle;

  void attach(SvgInteractiveMapHandle handle) {
    if (!identical(_handle, handle)) _handle = handle;
  }

  void detach(SvgInteractiveMapHandle handle) {
    if (identical(_handle, handle)) _handle = null;
  }

  void fit() => _handle?.fit();

  void zoomIn() => _handle?.zoomIn();

  void zoomOut() => _handle?.zoomOut();

  void focusRoom(RoomModel room) => _handle?.focusRoom(room);

  double? get currentScale => _handle?.currentScale;

  void dispose() => _handle = null;
}

abstract interface class SvgInteractiveMapHandle {
  double get currentScale;

  void fit();

  void zoomIn();

  void zoomOut();

  void focusRoom(RoomModel room);
}
