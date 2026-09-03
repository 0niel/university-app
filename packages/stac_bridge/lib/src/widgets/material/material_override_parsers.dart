import 'package:stac_bridge/src/widgets/material/material_button_parsers.dart';
import 'package:stac_bridge/src/widgets/material/material_form_parsers.dart';
import 'package:stac_bridge/src/widgets/material/material_shell_parsers.dart';
import 'package:stac_bridge/src/widgets/material/material_surface_parsers.dart';
import 'package:stac_framework/stac_framework.dart';

export 'material_button_parsers.dart';
export 'material_form_parsers.dart';
export 'material_icon_names.dart';
export 'material_shell_parsers.dart';
export 'material_surface_parsers.dart';

const List<StacParser<Object?>> materialOverrideParsers = [
  StacAlertDialogKitParser(),
  StacAppBarKitParser(),
  StacBadgeKitParser(),
  StacCardKitParser(),
  StacCheckBoxKitParser(),
  StacChipKitParser(),
  StacCircleAvatarKitParser(),
  StacCircularProgressKitParser(),
  StacDividerKitParser(),
  StacElevatedButtonKitParser(),
  StacFilledButtonKitParser(),
  StacFloatingActionButtonKitParser(),
  StacIconButtonKitParser(),
  StacImageKitParser(),
  StacLinearProgressKitParser(),
  StacListTileKitParser(),
  StacOutlinedButtonKitParser(),
  StacRadioKitParser(),
  StacSwitchKitParser(),
  StacTextButtonKitParser(),
  StacTextFieldKitParser(),
  StacTextFormFieldKitParser(),
  StacTooltipKitParser(),
  StacVerticalDividerKitParser(),
];
