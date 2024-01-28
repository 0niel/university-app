import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/router.dart';
import 'package:neon_framework/src/utils/exceptions.dart';
import 'package:neon_framework/src/widgets/error.dart';

@internal
class LoginQRcodePage extends StatefulWidget {
  const LoginQRcodePage({
    super.key,
  });

  @override
  State<LoginQRcodePage> createState() => _LoginQRcodePageState();
}

class _LoginQRcodePageState extends State<LoginQRcodePage> {
  String? _lastErrorURL;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: ReaderWidget(
            codeFormat: Format.qrCode,
            showGallery: false,
            showToggleCamera: false,
            showScannerOverlay: false,
            tryHarder: true,
            cropPercent: 0,
            scanDelaySuccess: const Duration(seconds: 3),
            onScan: (code) async {
              String? url;
              try {
                url = code.text;
                if (url == null) {
                  throw const InvalidQRcodeException();
                }
                final match = LoginQRcode.tryParse(url);
                if (match == null) {
                  throw const InvalidQRcodeException();
                }

                LoginCheckServerStatusRoute.withCredentials(
                  serverUrl: match.serverURL,
                  loginName: match.username,
                  password: match.password,
                ).pushReplacement(context);
              } catch (e, s) {
                if (_lastErrorURL != url) {
                  debugPrint(e.toString());
                  debugPrint(s.toString());

                  _lastErrorURL = url;
                  NeonError.showSnackbar(context, e);
                }
              }
            },
          ),
        ),
      );
}

/// Exception which is thrown when an invalid QR code is encountered.
@immutable
class InvalidQRcodeException extends NeonException {
  /// Creates a new [InvalidQRcodeException].
  const InvalidQRcodeException();

  @override
  NeonExceptionDetails get details => NeonExceptionDetails(
        getText: (context) => NeonLocalizations.of(context).errorInvalidQRcode,
      );
}
