export 'package:schedule/schedule.dart';

export 'src/clients/news_api_client.dart'
    show NewsApiClient, NewsApiMalformedResponse, NewsApiRequestFailure;
export 'src/clients/schedule_api_client.dart'
    show
        ScheduleApiClient,
        ScheduleApiMalformedResponse,
        ScheduleApiRequestFailure;
export 'src/data/news/models/models.dart' show Article;
export 'src/models/models.dart'
    show
        CategoriesResponse,
        NewsFeedResponse,
        NewsItemResponse,
        ScheduleResponse,
        SearchClassroomsResponse,
        SearchGroupsResponse,
        SearchTeachersResponse;
