/// API клиент предоставляет клиентский доступ к удаленному API.
library api_client;

export 'src/clients/schedule_api_client.dart'
    show
        ScheduleApiClient,
        ScheduleApiMalformedResponse,
        ScheduleApiRequestFailure;

export 'src/models/models.dart'
    show GroupsResponse, LessonResponse, ScheduleResponse;
