import 'package:file_icons/file_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:neon_files/src/blocs/files.dart';
import 'package:neon_files/src/models/file_details.dart';
import 'package:neon_framework/theme.dart';
import 'package:neon_framework/widgets.dart';
import 'package:nextcloud/core.dart';

class FilePreview extends StatelessWidget {
  const FilePreview({
    required this.bloc,
    required this.details,
    this.size = const Size.square(largeIconSize),
    this.color,
    this.borderRadius,
    this.withBackground = false,
    super.key,
  }) : assert(
          (borderRadius != null && withBackground) || borderRadius == null,
          'withBackground needs to be true when borderRadius is set',
        );

  final FilesBloc bloc;
  final FileDetails details;
  final Size size;
  final Color? color;
  final BorderRadius? borderRadius;
  final bool withBackground;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.primary;

    return SizedBox.fromSize(
      size: size,
      child: Builder(
        builder: (context) {
          if (details.isDirectory) {
            return Icon(
              MdiIcons.folder,
              color: color,
              size: size.shortestSide,
            );
          }

          return ValueListenableBuilder<bool>(
            valueListenable: bloc.options.showPreviewsOption,
            builder: (context, showPreviews, _) {
              if (showPreviews && (details.hasPreview ?? false)) {
                final preview = FilePreviewImage(
                  file: details,
                  size: size,
                );

                if (withBackground) {
                  return NeonImageWrapper(
                    borderRadius: borderRadius,
                    child: preview,
                  );
                }

                return preview;
              }

              return FileIcon(
                details.name,
                color: color,
                size: size.shortestSide,
              );
            },
          );
        },
      ),
    );
  }
}

class FilePreviewImage extends NeonApiImage {
  factory FilePreviewImage({
    required FileDetails file,
    required Size size,
  }) {
    final width = size.width.toInt();
    final height = size.height.toInt();
    final cacheKey = 'preview-${file.uri.path}-$width-$height';

    return FilePreviewImage._(
      file: file,
      size: size,
      cacheKey: cacheKey,
      width: width,
      height: height,
    );
  }

  FilePreviewImage._({
    required FileDetails file,
    required Size super.size,
    required super.cacheKey,
    required int width,
    required int height,
  }) : super(
          getImage: (client) async => client.core.preview.getPreview(
            file: file.uri.path,
            x: width,
            y: height,
          ),
          writeCache: (cacheManager, data) async {
            await cacheManager.putFile(
              cacheKey,
              data,
              maxAge: const Duration(days: 7),
              eTag: file.etag,
            );
          },
          isSvgHint: file.mimeType?.contains('svg') ?? false,
        );
}
