import 'package:app_ui/src/ninja/widgets/ninja_button_variant.dart';
import 'package:app_ui/src/widgets/buttons/app_button.dart';

extension NinjaButtonVariantX on NinjaButtonVariant {
  AppButtonVariant get app => switch (this) {
    NinjaButtonVariant.primary => AppButtonVariant.primary,
    NinjaButtonVariant.secondary ||
    NinjaButtonVariant.outline => AppButtonVariant.secondary,
    NinjaButtonVariant.tonal => AppButtonVariant.tonal,
    NinjaButtonVariant.text => AppButtonVariant.text,
    NinjaButtonVariant.destructive => AppButtonVariant.destructive,
    NinjaButtonVariant.destructiveOutline =>
      AppButtonVariant.destructiveOutline,
  };
}
