class LoginSuccessData {
  LoginSuccessData({
    required Map<String, String> allCookies,
    this.accessToken,
    this.specialCookieValue,
  }) : allCookies = Map.unmodifiable(allCookies);

  final String? accessToken;
  final Map<String, String> allCookies;
  final String? specialCookieValue;
}
