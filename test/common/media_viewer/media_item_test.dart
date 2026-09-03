import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';

void main() {
  group('MediaItem.kindOf', () {
    test('detects images by mime type', () {
      expect(
        MediaItem.kindOf(mimeType: 'image/png'),
        MediaKind.image,
      );
    });

    test('detects images by file extension', () {
      expect(
        MediaItem.kindOf(fileName: 'board.HEIC'),
        MediaKind.image,
      );
    });

    test('detects videos by mime type', () {
      expect(
        MediaItem.kindOf(mimeType: 'video/mp4'),
        MediaKind.video,
      );
    });

    test('detects videos by file extension', () {
      expect(
        MediaItem.kindOf(fileName: 'lecture.mov'),
        MediaKind.video,
      );
    });

    test('detects pdf by mime type', () {
      expect(
        MediaItem.kindOf(mimeType: 'application/pdf'),
        MediaKind.pdf,
      );
    });

    test('detects pdf by file extension', () {
      expect(
        MediaItem.kindOf(fileName: 'конспект.pdf'),
        MediaKind.pdf,
      );
    });

    test('falls back to file for unknown types', () {
      expect(
        MediaItem.kindOf(mimeType: 'application/zip', fileName: 'notes.zip'),
        MediaKind.file,
      );
    });

    test('falls back to file when nothing is provided', () {
      expect(MediaItem.kindOf(), MediaKind.file);
    });
  });

  group('MediaItem equality', () {
    test('is equal for same url and kind', () {
      const a = MediaItem(url: 'https://x/a.png', kind: MediaKind.image);
      const b = MediaItem(url: 'https://x/a.png', kind: MediaKind.image);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('differs when kind changes', () {
      const a = MediaItem(url: 'https://x/a', kind: MediaKind.image);
      const b = MediaItem(url: 'https://x/a', kind: MediaKind.file);
      expect(a == b, isFalse);
    });
  });
}
