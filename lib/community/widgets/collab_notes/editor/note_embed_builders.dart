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

part 'note_drawing_embed_builder.dart';

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
