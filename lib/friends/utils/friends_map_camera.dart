import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FriendsMapCamera {
  FriendsMapCamera(this._controller, {required this.vsync});

  static const Duration moveDuration = Duration(milliseconds: 700);
  static const double focusZoom = 16.5;

  final MapController _controller;
  final TickerProvider vsync;

  AnimationController? _moveController;
  Animation<double>? _moveAnimation;
  Tween<double>? _latitudeTween;
  Tween<double>? _longitudeTween;
  Tween<double>? _zoomTween;

  void focusOn(
    double latitude,
    double longitude, {
    required bool animate,
  }) {
    if (!latitude.isFinite || !longitude.isFinite) return;
    moveTo(LatLng(latitude, longitude), focusZoom, animate: animate);
  }

  void moveTo(
    LatLng destination,
    double destinationZoom, {
    required bool animate,
  }) {
    if (!destination.latitude.isFinite || !destination.longitude.isFinite) {
      return;
    }
    if (!animate) {
      _controller.move(destination, destinationZoom);
      return;
    }
    final camera = _controller.camera;
    if (!camera.center.latitude.isFinite || !camera.center.longitude.isFinite) {
      _controller.move(destination, destinationZoom);
      return;
    }
    dispose();
    _latitudeTween = Tween(
      begin: camera.center.latitude,
      end: destination.latitude,
    );
    _longitudeTween = Tween(
      begin: camera.center.longitude,
      end: destination.longitude,
    );
    _zoomTween = Tween(begin: camera.zoom, end: destinationZoom);

    final controller = AnimationController(
      vsync: vsync,
      duration: moveDuration,
    );
    _moveController = controller;
    _moveAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    );
    controller.addListener(_onTick);
    unawaited(controller.forward());
  }

  void _onTick() {
    final animation = _moveAnimation;
    final latitudeTween = _latitudeTween;
    final longitudeTween = _longitudeTween;
    final zoomTween = _zoomTween;
    if (animation == null ||
        latitudeTween == null ||
        longitudeTween == null ||
        zoomTween == null) {
      return;
    }
    _controller.move(
      LatLng(
        latitudeTween.evaluate(animation),
        longitudeTween.evaluate(animation),
      ),
      zoomTween.evaluate(animation),
    );
  }

  void dispose() {
    _moveController?.removeListener(_onTick);
    _moveController
      ?..stop()
      ..dispose();
    _moveController = null;
    _moveAnimation = null;
    _latitudeTween = null;
    _longitudeTween = null;
    _zoomTween = null;
  }
}
