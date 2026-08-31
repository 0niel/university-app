enum WatchMessageAction {
  requestPassId,
  requestSchedule,
  openPhoneAppForBinding,
  unknown;

  static WatchMessageAction fromString(String? action) => switch (action) {
    'requestPassId' => .requestPassId,
    'requestSchedule' => .requestSchedule,
    'openPhoneAppForBinding' => .openPhoneAppForBinding,
    _ => .unknown,
  };
}
