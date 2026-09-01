import 'package:flutter/foundation.dart';

String deviceLabelFor(TargetPlatform platform) => switch (platform) {
  TargetPlatform.android => 'Android device',
  TargetPlatform.iOS => 'Apple mobile device',
  TargetPlatform.macOS => 'Mac',
  TargetPlatform.windows => 'Windows PC',
  TargetPlatform.linux => 'Linux computer',
  TargetPlatform.fuchsia => 'Mobile device',
};
