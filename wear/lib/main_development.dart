import 'dart:async';

import 'package:wear/app/app.dart';
import 'package:wear/bootstrap.dart';

void main() {
  unawaited(bootstrap(() => const App()));
}
