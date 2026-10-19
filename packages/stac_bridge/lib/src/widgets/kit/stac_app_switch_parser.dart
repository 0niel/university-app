import 'package:stac_bridge/src/widgets/kit/kit_choice_parsers.dart';

class StacAppSwitchParser extends StacAppToggleParser {
  const StacAppSwitchParser();

  @override
  String get type => 'appSwitch';
}
