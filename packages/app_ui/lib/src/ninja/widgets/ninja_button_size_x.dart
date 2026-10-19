import 'package:app_ui/src/ninja/widgets/ninja_button_size.dart';
import 'package:app_ui/src/widgets/buttons/app_button.dart';

extension NinjaButtonSizeX on NinjaButtonSize {
  AppButtonSize get app => switch (this) {
    NinjaButtonSize.small => AppButtonSize.small,
    NinjaButtonSize.medium || NinjaButtonSize.standard => AppButtonSize.medium,
    NinjaButtonSize.large => AppButtonSize.large,
    NinjaButtonSize.hero => AppButtonSize.hero,
  };

  double get height => app.height;
}
