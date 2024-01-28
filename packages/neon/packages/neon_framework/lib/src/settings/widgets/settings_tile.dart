import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/src/settings/models/option.dart';

@internal
abstract class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
  });
}

@internal
abstract class InputSettingsTile<T extends Option<dynamic>> extends SettingsTile {
  const InputSettingsTile({
    required this.option,
    super.key,
  });

  final T option;
}
