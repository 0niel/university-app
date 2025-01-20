import 'dart:io';

import 'package:cli_completion/cli_completion.dart';
import 'package:nfc_pass_client/nfc_pass_client.dart';

class ExampleCommandRunner extends CompletionCommandRunner<int> {
  ExampleCommandRunner()
      : super(
          'example',
          'A command-line tool to demonstrate the usage of the nfc_pass_client'
              'package.',
        );

  @override
  Future<int> run(Iterable<String> args) async {
    final client = NfcPassClient(
      cookieProvider: () async {
        return '...';
      },
    );

    final jwt = await client.getAccessTokenForDigitalPass();
    print('Your JWT: $jwt');

    await client.sendVerificationCode(jwt);

    print('Enter the code from the email:');
    final code = stdin.readLineSync();

    final digitalPass = await client.getDigitalPass(
      bearerToken: jwt,
      sixDigitCode: code!,
      deviceName: 'iPhone 12 Pro Max',
    );

    print('Your digital pass: $digitalPass');

    return 0;
  }
}
