import 'package:pdfx/pdfx.dart';

class MediaPdfDocument {
  MediaPdfDocument(this.document)
    : controller = PdfControllerPinch(document: Future.value(document));

  final PdfDocument document;
  final PdfControllerPinch controller;
  Future<void>? _closeOperation;

  Future<void> close() => _closeOperation ??= _close();

  Future<void> _close() async {
    controller.dispose();
    controller.pageListenable.dispose();
    controller.loadingState.dispose();
    await document.close();
  }
}
