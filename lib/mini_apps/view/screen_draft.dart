part of 'mini_app_submit_page.dart';

class ScreenDraft {
  ScreenDraft({required String path, String json = ''})
    : pathController = TextEditingController(text: path),
      jsonController = TextEditingController(text: json);

  final TextEditingController pathController;

  final TextEditingController jsonController;

  void dispose() {
    pathController.dispose();
    jsonController.dispose();
  }
}
