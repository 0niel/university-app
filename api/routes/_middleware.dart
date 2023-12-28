import 'package:dart_frog/dart_frog.dart';

import 'package:university_app_server_api/api.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(userProvider())
      .use(newsDataSourceProvider())
      .use(scheduleDataSourceProvider())
      .use(communityDataSourceProvider());
}
