import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return Response(body: 'ok');
}
