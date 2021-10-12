// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/api.dart' as crypto;

class ForumLoginPage extends StatelessWidget {
  ForumLoginPage({Key? key}) : super(key: key);

  final RsaKeyHelper _rsaKeyHelper = RsaKeyHelper();
  late crypto.AsymmetricKeyPair _asymmetricKeyPair;
  late Map<String, Object> _params;

  String _getPublicKey() {
    return _rsaKeyHelper.encodePublicKeyToPemPKCS1(
        _asymmetricKeyPair.publicKey as RSAPublicKey);
  }

  String _getPrivateKey() {
    return _rsaKeyHelper.encodePrivateKeyToPemPKCS1(
        _asymmetricKeyPair.privateKey as RSAPrivateKey);
  }

  Future<bool> _computeRSAKeys() async {
    _asymmetricKeyPair =
        await _rsaKeyHelper.computeRSAKeyPair(_rsaKeyHelper.getSecureRandom());

    _params = {
      'scopes': 'notifications,session_info',
      'client_id': '109',
      'nonce': DateTime.now().toString(),
      'auth_redirect': 'discourse://auth_redirect',
      'application_name': 'MireaApp',
      'public_key': _getPublicKey(),
    };

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Профиль',
          style: DarkTextTheme.title,
        ),
      ),
      body: FutureBuilder<bool>(
        future: _computeRSAKeys(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var queryString = Uri(queryParameters: _params).query;
            return InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse(
                    "https://mirea.ninja/user-api-key/new?$queryString"),
              ),
              onLoadStart: (controller, url) {
                if (url.toString().contains('discourse://auth_redirect')) {
                  var uri = Uri.parse(url.toString());
                  String payload = uri.queryParameters['payload']!;
                  // ignore: unused_local_variable
                  String decryptedString = decrypt(
                      payload, _asymmetricKeyPair.privateKey as RSAPrivateKey);
                }
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
