import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_filter.dart';
import 'package:rtu_mirea_app/free_rooms/utils/room_photo_intake.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_gallery_body.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/services/room_key.dart';

enum RoomPhotoGalleryStatus { loading, loaded, error, offline }

class RoomPhotoGallery extends StatefulWidget {
  const RoomPhotoGallery({
    required this.campus,
    required this.roomName,
    super.key,
  });

  final String campus;
  final String roomName;

  @override
  State<RoomPhotoGallery> createState() => _RoomPhotoGalleryState();
}

class _RoomPhotoGalleryState extends State<RoomPhotoGallery> {
  final _heroScope = Object();

  final _picker = ImagePicker();
  final _pageController = PageController();
  RoomPhotoGalleryStatus _status = RoomPhotoGalleryStatus.loading;
  List<RoomPhoto> _photos = const [];
  int _index = 0;
  int _uploadTotal = 0;
  int _uploadDone = 0;

  String get _campusKey => campusKey(widget.campus);
  String get _roomKey => roomKey(widget.roomName);
  bool get _uploading => _uploadTotal > 0;

  CampusRepository get _repository => context.read<CampusRepository>();

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (_roomKey.isEmpty) {
      setState(() => _status = RoomPhotoGalleryStatus.error);
      return;
    }
    setState(() => _status = RoomPhotoGalleryStatus.loading);
    try {
      final photos = await _repository.getRoomPhotos(
        campus: _campusKey,
        roomKey: _roomKey,
      );
      if (!mounted) return;
      setState(() {
        _photos = photos;
        _index = 0;
        _status = RoomPhotoGalleryStatus.loaded;
      });
    } on SocketException {
      if (mounted) setState(() => _status = RoomPhotoGalleryStatus.offline);
    } on Object {
      if (mounted) setState(() => _status = RoomPhotoGalleryStatus.error);
    }
  }

  Future<void> _openPicker() async {
    final l10n = context.l10n;
    final navigator = Navigator.of(context, rootNavigator: true);
    final source = await showAppSheet<ImageSource>(
      context,
      title: l10n.roomPhotoAdd,
      child: AppListGroup(
        children: [
          AppListRow(
            title: l10n.lessonDetailsCamera,
            leading: const AppLineIconWidget(AppLineIcon.camera),
            strong: true,
            showChevron: false,
            onTap: () => navigator.pop(ImageSource.camera),
          ),
          AppListRow(
            title: l10n.lessonDetailsGallery,
            leading: const AppLineIconWidget(AppLineIcon.image),
            strong: true,
            showChevron: false,
            onTap: () => navigator.pop(ImageSource.gallery),
          ),
        ],
      ),
    );
    if (source == null || !mounted) return;
    await _pick(source);
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final files = source == ImageSource.camera
          ? await _pickFromCamera()
          : await _picker.pickMultiImage(maxWidth: 1600, imageQuality: 85);
      if (files.isEmpty) return;
      await _upload(
        files.take(CampusRepository.roomPhotoMaxPerUpload).toList(),
      );
    } on Object {
      if (mounted) _showToast(context.l10n.lostFoundImageError, error: true);
    }
  }

  Future<List<XFile>> _pickFromCamera() async {
    final file = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1600,
      imageQuality: 85,
    );
    return file == null ? const [] : [file];
  }

  Future<void> _upload(List<XFile> files) async {
    setState(() {
      _uploadTotal = files.length;
      _uploadDone = 0;
    });
    var failures = 0;
    for (final file in files) {
      try {
        final upload = await RoomPhotoIntake.read(file);
        if (upload == null) {
          failures++;
          continue;
        }
        final size = await _decodeSize(upload.bytes);
        final photo = await _repository.addRoomPhoto(
          campus: _campusKey,
          roomKey: _roomKey,
          bytes: upload.bytes,
          contentType: upload.contentType,
          width: size?.$1,
          height: size?.$2,
        );
        if (!mounted) return;
        setState(() {
          _photos = [photo, ..._photos];
          _status = RoomPhotoGalleryStatus.loaded;
        });
      } on Object {
        failures++;
      } finally {
        if (mounted) setState(() => _uploadDone++);
      }
    }
    if (!mounted) return;
    setState(() {
      _uploadTotal = 0;
      _uploadDone = 0;
    });
    if (failures == 0) {
      _showToast(context.l10n.roomPhotoUploaded);
    } else {
      _showToast(context.l10n.roomPhotoUploadFailed, error: true);
    }
  }

  Future<(int, int)?> _decodeSize(Uint8List bytes) async {
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final size = (frame.image.width, frame.image.height);
      frame.image.dispose();
      return size;
    } on Object {
      return null;
    }
  }

  Future<void> _confirmDelete(RoomPhoto photo) async {
    final l10n = context.l10n;
    final confirmed = await showAppConfirmDialog(
      context,
      title: l10n.roomPhotoDeleteConfirmTitle,
      message: l10n.roomPhotoDeleteConfirmMessage,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    final previous = _photos;
    setState(() {
      _photos = _photos.where((candidate) => candidate.id != photo.id).toList();
      _index = _index.clamp(0, _photos.isEmpty ? 0 : _photos.length - 1);
    });
    try {
      await _repository.deleteRoomPhoto(photo.id);
      if (mounted) _showToast(context.l10n.roomPhotoDeleted);
    } on Object {
      if (!mounted) return;
      setState(() => _photos = previous);
      _showToast(context.l10n.roomPhotoDeleteFailed, error: true);
    }
  }

  void _showToast(String message, {bool error = false}) {
    if (error) {
      ToastManager.showError(context, message: message);
    } else {
      ToastManager.showSuccess(context, message: message);
    }
  }

  Future<void> _openViewer(int index) => showMediaViewer(
    context,
    initialIndex: index,
    items: [
      for (final (index, photo) in _photos.indexed)
        MediaItem(
          url: photo.url,
          kind: MediaKind.image,
          heroTag: (_heroScope, index, photo.id),
        ),
    ],
  );

  @override
  Widget build(BuildContext context) => RoomPhotoGalleryBody(
    status: _status,
    photos: _photos,
    heroScope: _heroScope,
    index: _index,
    pageController: _pageController,
    uploadDone: _uploadDone,
    uploadTotal: _uploadTotal,
    onIndexChanged: (index) => setState(() => _index = index),
    onRetry: () => unawaited(_load()),
    onAddPhoto: _uploading ? null : () => unawaited(_openPicker()),
    onOpenPhoto: (index) => unawaited(_openViewer(index)),
    onDeletePhoto: (photo) => unawaited(_confirmDelete(photo)),
  );
}
