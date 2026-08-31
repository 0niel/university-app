import 'dart:io';

import 'package:cli_completion/cli_completion.dart';
import 'package:nfc_pass_client/nfc_pass_client.dart';

class CommandRunner extends CompletionCommandRunner<int> {
  CommandRunner()
      : super(
          'example',
          'A command-line tool to demonstrate the usage of the nfc_pass_client '
              'package.',
        );

  @override
  Future<int> run(Iterable<String> args) async {
    final client = NfcPassClient(
      cookieProvider: () async {
        return '...';
      },
      endpoints: NfcPassEndpoints(
        accessTokenUrl: Uri(scheme: 'https', host: 'api.university.example'),
        sendVerificationCodeUrl: Uri(
          scheme: 'https',
          host: 'api.university.example',
        ),
        getDigitalPassUrl: Uri(
          scheme: 'https',
          host: 'api.university.example',
        ),
      ),
    );

    final jwt = await client.getAccessTokenForDigitalPass();
    stdout.writeln('Your JWT: $jwt');

    await client.sendVerificationCode(jwt);

    stdout.writeln('Enter the code from the email:');
    final code = stdin.readLineSync();

    final digitalPass = await client.getDigitalPass(
      bearerToken: jwt,
      sixDigitCode: code!,
      deviceName: 'iPhone 12 Pro Max',
    );

    stdout.writeln('Your digital pass: $digitalPass');

    return 0;
  }
}
