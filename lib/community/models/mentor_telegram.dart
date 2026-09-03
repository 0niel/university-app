final mentorTelegramHandlePattern = RegExp(r'^[a-zA-Z0-9_]{5,32}$');

String normalizeMentorTelegramHandle(String value) =>
    value.trim().replaceFirst(RegExp('^@'), '');

bool isValidMentorTelegramHandle(String value) =>
    mentorTelegramHandlePattern.hasMatch(normalizeMentorTelegramHandle(value));

Uri? mentorTelegramUri(String? handle) {
  if (handle == null) return null;
  final normalized = normalizeMentorTelegramHandle(handle);
  if (!mentorTelegramHandlePattern.hasMatch(normalized)) return null;
  return Uri.https('t.me', '/$normalized');
}
