import 'package:stac_bridge/src/widgets/kit/kit_avatar_parsers.dart';
import 'package:stac_bridge/src/widgets/kit/kit_banner_parsers.dart';
import 'package:stac_bridge/src/widgets/kit/kit_button_parsers.dart';
import 'package:stac_bridge/src/widgets/kit/kit_calendar_month_parser.dart';
import 'package:stac_bridge/src/widgets/kit/kit_calendar_parsers.dart';
import 'package:stac_bridge/src/widgets/kit/kit_chip_parsers.dart';
import 'package:stac_bridge/src/widgets/kit/kit_choice_parsers.dart';
import 'package:stac_bridge/src/widgets/kit/kit_image_parser.dart';
import 'package:stac_bridge/src/widgets/kit/kit_input_parsers.dart';
import 'package:stac_bridge/src/widgets/kit/kit_label_parsers.dart';
import 'package:stac_bridge/src/widgets/kit/kit_progress_parsers.dart';
import 'package:stac_bridge/src/widgets/kit/kit_segment_parsers.dart';
import 'package:stac_bridge/src/widgets/kit/kit_select_parsers.dart';
import 'package:stac_bridge/src/widgets/kit/kit_status_parsers.dart';
import 'package:stac_bridge/src/widgets/kit/kit_surface_parsers.dart';
import 'package:stac_bridge/src/widgets/kit/kit_text_parsers.dart';
import 'package:stac_bridge/src/widgets/kit/kit_tile_parsers.dart';
import 'package:stac_bridge/src/widgets/stac_app_state_scope.dart';
import 'package:stac_framework/stac_framework.dart';

export 'kit_avatar_parsers.dart';
export 'kit_banner_parsers.dart';
export 'kit_button_parsers.dart';
export 'kit_calendar_month_parser.dart';
export 'kit_calendar_parsers.dart';
export 'kit_chip_parsers.dart';
export 'kit_choice_parsers.dart';
export 'kit_image_parser.dart';
export 'kit_input_parsers.dart';
export 'kit_label_parsers.dart';
export 'kit_progress_parsers.dart';
export 'kit_segment_parsers.dart';
export 'kit_select_parsers.dart';
export 'kit_status_parsers.dart';
export 'kit_surface_parsers.dart';
export 'kit_text_parsers.dart';
export 'kit_tile_parsers.dart';

const List<StacParser<Object?>> kitWidgetParsers = [
  StacAppAvatarParser(),
  StacAppAvatarStackParser(),
  StacAppBadgeParser(),
  StacAppBannerParser(),
  StacAppButtonParser(),
  StacAppCalendarMonthParser(),
  StacAppCardParser(),
  StacAppCheckboxParser(),
  StacAppChipParser(),
  StacAppChipRowParser(),
  StacAppCountBadgeParser(),
  StacAppDeadlineRowParser(),
  StacAppDividerParser(),
  StacAppEmptyStateParser(),
  StacAppErrorStateParser(),
  StacAppExpandableTextParser(),
  StacAppFabParser(),
  StacAppHashTagParser(),
  StacAppIconButtonParser(),
  StacAppIconTileParser(),
  StacAppImageParser(),
  StacAppInputFieldParser(),
  StacAppLessonRowParser(),
  StacAppLineIconParser(),
  StacAppListGroupParser(),
  StacAppListRowParser(),
  StacAppLiveBadgeParser(),
  StacAppMetaPillParser(),
  StacAppOverlineParser(),
  StacAppProgressBarParser(),
  StacAppProgressRingParser(),
  StacAppRadioParser(),
  StacAppSearchFieldParser(),
  StacAppSectionTitleParser(),
  StacAppSegmentedControlParser(),
  StacAppSelectFieldParser(),
  StacAppServiceTileParser(),
  StacAppSkeletonParser(),
  StacAppSmartChipParser(),
  StacAppSpinnerParser(),
  StacAppStateScopeParser(),
  StacAppStepperParser(),
  StacAppSwitchParser(),
  StacAppTabsParser(),
  StacAppTagParser(),
  StacAppTextParser(),
  StacAppToggleParser(),
  StacAppTooltipParser(),
  StacAppTypeTagParser(),
  StacAppWeekStripParser(),
];
