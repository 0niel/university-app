import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:rtu_mirea_app/community/view/collab_note_drawing_page.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/drawing_stroke.dart';

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
    return GestureDetector(
      onTap: embedContext.readOnly
          ? null
          : () => unawaited(_reopen(context, embedContext, url, strokesJson)),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: url.isEmpty
              ? ColoredBox(color: context.colors.surface2)
              : CachedNetworkImage(imageUrl: url, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Future<void> _reopen(
    BuildContext context,
    EmbedContext embedContext,
    String url,
    String strokesJson,
  ) async {
    final strokes = decodeDrawingStrokes(strokesJson);
    final result = await showCollabNoteDrawingPage(
      context,
      initialStrokes: strokes,
    );
    if (result == null || !context.mounted) return;
    final repository = context.read<CampusRepository>();
    final newUrl = await repository.uploadNoteMedia(
      bytes: result.bytes,
      contentType: 'image/png',
      extension: 'png',
    );
    final offset = embedContext.node.offset;
    embedContext.controller.replaceText(
      offset,
      1,
      Embeddable('note-drawing', {
        'url': newUrl,
        'strokes': result.strokesJson,
      }),
      TextSelection.collapsed(offset: offset + 1),
    );
  }
}
