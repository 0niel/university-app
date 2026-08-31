final class HomeLatestRequest {
  int _revision = 0;

  int begin() => ++_revision;

  bool accepts(int revision) => revision == _revision;
}
