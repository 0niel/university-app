import 'package:nfc_pass_client/nfc_pass_client.dart';

/// OAuth and gRPC settings for an institution's NFC-pass provider.
final class NfcPassConfiguration {
  /// Creates settings for a provider that supports the digital-pass protocol.
  const NfcPassConfiguration({
    required this.oauthUrl,
    required this.expectedRedirectUrls,
    required this.endpoints,
  });

  /// Starts the provider's interactive authentication flow.
  final Uri oauthUrl;

  /// Redirect destinations that complete authentication successfully.
  final List<Uri> expectedRedirectUrls;

  /// gRPC-Web endpoints used after authentication.
  final NfcPassEndpoints endpoints;
}
