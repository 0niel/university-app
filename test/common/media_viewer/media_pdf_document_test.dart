import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfx/pdfx.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_pdf_document.dart';

class _Document extends Fake implements PdfDocument {
  _Document({this.closeGate});

  final Completer<void>? closeGate;
  int closeCalls = 0;

  @override
  bool isClosed = false;

  @override
  Future<void> close() async {
    closeCalls++;
    isClosed = true;
    await closeGate?.future;
  }
}

void main() {
  test(
    'closing before a PDF view attaches releases the native document',
    () async {
      void listener() {}
      final source = _Document();
      final document = MediaPdfDocument(source);
      expect(await document.controller.document, same(source));

      await document.close();

      expect(source.isClosed, isTrue);
      expect(source.closeCalls, 1);
      expect(
        () => document.controller.addListener(listener),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => document.controller.pageListenable.addListener(listener),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => document.controller.loadingState.addListener(listener),
        throwsA(isA<FlutterError>()),
      );
    },
  );

  test(
    'concurrent cleanup closes the same native document only once',
    () async {
      final closeGate = Completer<void>();
      final source = _Document(closeGate: closeGate);
      final document = MediaPdfDocument(source);

      final first = document.close();
      final second = document.close();
      expect(source.closeCalls, 1);

      closeGate.complete();
      await Future.wait([first, second]);
      await document.close();
      expect(source.closeCalls, 1);
    },
  );
}
