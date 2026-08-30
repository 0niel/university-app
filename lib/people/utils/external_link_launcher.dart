import 'package:url_launcher/url_launcher.dart';

class ExternalLinkLauncher {
  const ExternalLinkLauncher();

  Future<bool> open(Uri uri) => launchUrl(uri, mode: .externalApplication);
}
