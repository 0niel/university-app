class AutoFillConfig {
  const AutoFillConfig({
    this.usernameSelector,
    this.passwordSelector,
    this.submitButtonSelector,
    this.defaultUsername,
    this.defaultPassword,
    this.additionalFields = const {},
  });

  final String? usernameSelector;
  final String? passwordSelector;
  final String? submitButtonSelector;
  final String? defaultUsername;
  final String? defaultPassword;
  final Map<String, String> additionalFields;
}
