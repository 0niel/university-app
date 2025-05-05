import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoteConfigClient {
  RemoteConfigClient({required this.configUrl});
  final String configUrl;

  Future<Map<String, dynamic>> fetchConfig() async {
    final response = await http.get(Uri.parse(configUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Ошибка загрузки конфигурации. Код: ${response.statusCode}');
    }
  }
}
