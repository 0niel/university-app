import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_details_page/material_badge.dart';

void main() {
  group('fileTypeBadge', () {
    test('uses a short extension verbatim', () {
      expect(fileTypeBadge('lecture7.pdf', 'application/pdf'), 'PDF');
      expect(fileTypeBadge('notes.docx', null), 'DOCX');
    });

    test('trims a long extension to three letters', () {
      expect(fileTypeBadge('lab07_mnist.ipynb', null), 'IPY');
    });

    test('falls back to the MIME type when there is no usable extension', () {
      expect(fileTypeBadge('board photo', 'image/jpeg'), 'IMG');
      expect(fileTypeBadge('scan', 'application/pdf'), 'PDF');
    });

    test('defaults to DOC for unknown files', () {
      expect(fileTypeBadge('mystery', null), 'DOC');
    });
  });
}
