import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/provisioning_api.dart';

Future<void> main() async {
  final client = NextcloudClient(
    Uri.parse('http://localhost'),
    loginName: 'admin',
    password: 'admin',
  );

  final response = await client.provisioningApi.users.getCurrentUser();
  print(response.body.ocs.data.id); // Will print `admin`
}
