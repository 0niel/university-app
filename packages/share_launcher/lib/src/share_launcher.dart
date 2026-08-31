import 'package:share_launcher/src/share_failure.dart';
import 'package:share_plus/share_plus.dart';

export 'package:share_launcher/src/share_failure.dart';

typedef ShareProvider = Future<void> Function(String);

class ShareLauncher {
  const ShareLauncher({ShareProvider? shareProvider})
    : onShare = shareProvider ?? _shareWithSystemSheet;

  final ShareProvider onShare;

  static Future<void> _shareWithSystemSheet(String text) async {
    await SharePlus.instance.share(ShareParams(text: text));
  }

  Future<void> share({required String text}) async {
    try {
      await onShare(text);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ShareFailure(error), stackTrace);
    }
  }
}
