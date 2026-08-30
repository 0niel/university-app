import 'package:url_launcher/url_launcher.dart';

abstract interface class LostFoundContactLauncher {
  Future<bool> openTelegram(String value);

  Future<bool> call(String value);
}

final class UrlLostFoundContactLauncher implements LostFoundContactLauncher {
  const UrlLostFoundContactLauncher();

  @override
  Future<bool> openTelegram(String value) async {
    final uri = telegramUri(value);
    if (uri == null) return false;
    return _launch(uri, .externalApplication);
  }

  @override
  Future<bool> call(String value) async {
    final uri = phoneUri(value);
    if (uri == null) return false;
    return _launch(uri, .platformDefault);
  }

  static Uri? telegramUri(String value) {
    final handle = value.trim().replaceFirst('@', '');
    if (!RegExp(r'^[A-Za-z0-9_]{5,32}$').hasMatch(handle)) return null;
    return Uri.https('t.me', '/$handle');
  }

  static Uri? phoneUri(String value) {
    final phone = value.replaceAll(RegExp('[ ()-]'), '');
    if (!RegExp(r'^[+]?[0-9]{7,15}$').hasMatch(phone)) return null;
    return Uri(scheme: 'tel', path: phone);
  }

  Future<bool> _launch(Uri uri, LaunchMode mode) async {
    try {
      return await launchUrl(uri, mode: mode);
    } on Exception {
      return false;
    }
  }
}
