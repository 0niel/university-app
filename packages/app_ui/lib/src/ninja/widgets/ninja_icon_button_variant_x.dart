import 'package:app_ui/src/ninja/widgets/ninja_icon_button_variant.dart';
import 'package:app_ui/src/widgets/buttons/app_button.dart';

extension NinjaIconButtonVariantX on NinjaIconButtonVariant {
  AppIconButtonTone get tone => switch (this) {
    NinjaIconButtonVariant.outline => AppIconButtonTone.secondary,
    NinjaIconButtonVariant.filled => AppIconButtonTone.primary,
    NinjaIconButtonVariant.surface => AppIconButtonTone.surface,
    NinjaIconButtonVariant.tonal => AppIconButtonTone.tonal,
    NinjaIconButtonVariant.plain => AppIconButtonTone.plain,
  };
}
