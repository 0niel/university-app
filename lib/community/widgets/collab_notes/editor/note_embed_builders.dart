import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/community/view/collab_note_drawing_page.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/drawing_stroke.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

List<EmbedBuilder> noteEmbedBuilders({
  required ValueChanged<String> onImageTap,
}) {
  return [
    QuillEditorImageEmbedBuilder(
      config: QuillEditorImageEmbedConfig(
        imageProviderBuilder: (context, imageUrl) => imageUrl.startsWith('http')
            ? CachedNetworkImageProvider(imageUrl)
            : null,
        onImageClicked: onImageTap,
      ),
    ),
    const NoteDrawingEmbedBuilder(),
  ];
}

class NoteDrawingEmbedBuilder extends EmbedBuilder {
  const NoteDrawingEmbedBuilder();

  @override
  String get key => 'note-drawing';

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final data = embedContext.node.value.data;
    final map = data is Map
        ? Map<String, Object?>.from(data)
        : const <String, Object?>{};
    final url = map['url'] as String? ?? '';
    final strokesJson = map['strokes'] as String? ?? '[]';
    return _NoteDrawingEmbed(
      embedContext: embedContext,
      url: url,
      strokesJson: strokesJson,
    );
  }
}

class _NoteDrawingEmbed extends StatefulWidget {
  const _NoteDrawingEmbed({
    required this.embedContext,
    required this.url,
    required this.strokesJson,
  });

  final EmbedContext embedContext;
  final String url;
  final String strokesJson;

  @override
  State<_NoteDrawingEmbed> createState() => _NoteDrawingEmbedState();
}

class _NoteDrawingEmbedState extends State<_NoteDrawingEmbed> {
  final _heroTag = Object();
  late List<DrawingStroke> _strokes;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _strokes = decodeDrawingStrokes(widget.strokesJson);
  }

  @override
  void didUpdateWidget(_NoteDrawingEmbed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.strokesJson != widget.strokesJson) {
      _strokes = decodeDrawingStrokes(widget.strokesJson);
    }
  }

  void _preview() => unawaited(
    showMediaViewer(
      context,
      items: [MediaItem(url: widget.url, kind: .image, heroTag: _heroTag)],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final size = _strokes
        .map((stroke) => stroke.canvasSize)
        .nonNulls
        .firstOrNull;
    Widget placeholder() => AspectRatio(
      aspectRatio: size?.aspectRatio ?? 4 / 3,
      child: ColoredBox(color: context.colors.surface2),
    );
    var image = widget.url.isEmpty
        ? placeholder()
        : CachedNetworkImage(
            imageUrl: widget.url,
            width: double.infinity,
            fit: BoxFit.contain,
            placeholder: (_, _) => placeholder(),
            errorWidget: (_, _, _) => placeholder(),
          );
    if (size != null && widget.url.isNotEmpty) {
      image = AspectRatio(aspectRatio: size.aspectRatio, child: image);
    }
    final readOnly =
        widget.embedContext.readOnly || widget.embedContext.controller.readOnly;
    return GestureDetector(
      onTap: _editing
          ? null
          : readOnly
          ? widget.url.isEmpty
                ? null
                : _preview
          : () => unawaited(_reopen()),
      onLongPress: widget.url.isEmpty ? null : _preview,
      child: Hero(
        tag: _heroTag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: image,
        ),
      ),
    );
  }

  Future<void> _reopen() async {
    final controller = widget.embedContext.controller;
    final document = controller.document;
    final node = widget.embedContext.node;
    final value = node.value;
    bool canEdit() {
      if (!mounted ||
          widget.embedContext.readOnly ||
          controller.readOnly ||
          !identical(widget.embedContext.controller, controller) ||
          !identical(widget.embedContext.node, node) ||
          !identical(controller.document, document) ||
          !identical(node.value, value) ||
          node.parent == null) {
        return false;
      }
      final offset = node.documentOffset;
      return offset >= 0 &&
          offset < document.length - 1 &&
          identical(document.querySegmentLeafNode(offset).leaf, node);
    }

    if (_editing || !canEdit()) return;
    setState(() => _editing = true);
    try {
      final result = await showCollabNoteDrawingPage(
        context,
        initialStrokes: _strokes,
      );
      if (result == null || !mounted || !canEdit()) return;
      final repository = context.read<CampusRepository>();
      final newUrl = await repository.uploadNoteMedia(
        bytes: result.bytes,
        contentType: 'image/png',
        extension: 'png',
      );
      if (!canEdit()) return;
      if (newUrl.isEmpty) throw StateError('Empty drawing URL');
      final offset = node.documentOffset;
      controller.replaceText(
        offset,
        1,
        Embeddable('note-drawing', {
          'url': newUrl,
          'strokes': result.strokesJson,
        }),
        TextSelection.collapsed(offset: offset + 1),
      );
    } on Object {
      if (mounted) {
        showNinjaToast(
          context,
          showCheck: false,
          message: context.l10n.noteImageUploadError,
        );
      }
    } finally {
      if (mounted) setState(() => _editing = false);
    }
  }
}
