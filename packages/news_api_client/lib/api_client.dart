/// API клиент предоставляет клиентский доступ к удаленному API.
library api_client;

export 'src/client/news_api_client.dart'
    show NewsApiClient, NewsApiMalformedResponse, NewsApiRequestFailure;

export 'src/models/models.dart'
    show NewsResponse;
