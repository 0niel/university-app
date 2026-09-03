import 'package:app_ui/app_ui.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

AppLineIcon? lineIconForMaterial(String? name) => switch (name) {
  'add' || 'add_circle' || 'add_circle_outline' => AppLineIcon.plus,
  'remove' || 'remove_circle_outline' => AppLineIcon.minus,
  'close' || 'cancel' || 'clear' => AppLineIcon.close,
  'check' || 'done' || 'check_circle' => AppLineIcon.check,
  'edit' || 'create' || 'mode_edit' => AppLineIcon.pencil,
  'delete' || 'delete_outline' => AppLineIcon.trash,
  'share' || 'ios_share' => AppLineIcon.share,
  'search' => AppLineIcon.search,
  'favorite' || 'favorite_border' => AppLineIcon.heart,
  'star' || 'star_border' || 'star_outline' => AppLineIcon.star,
  'settings' => AppLineIcon.settings,
  'notifications' || 'notifications_none' => AppLineIcon.bell,
  'home' => AppLineIcon.home,
  'calendar_today' || 'calendar_month' || 'event' => AppLineIcon.calendar,
  'map' || 'place' || 'location_on' => AppLineIcon.pin,
  'refresh' || 'sync' => AppLineIcon.refresh,
  'arrow_forward' || 'arrow_right_alt' => AppLineIcon.arrowRight,
  'arrow_back' || 'arrow_back_ios' || 'chevron_left' => AppLineIcon.chevronL,
  'chevron_right' || 'arrow_forward_ios' => AppLineIcon.chevronR,
  'expand_more' || 'keyboard_arrow_down' => AppLineIcon.chevronD,
  'expand_less' || 'keyboard_arrow_up' => AppLineIcon.chevronU,
  'more_vert' || 'more_horiz' => AppLineIcon.more,
  'filter_list' || 'tune' => AppLineIcon.filter,
  'person' || 'person_outline' || 'account_circle' => AppLineIcon.user,
  'people' || 'group' => AppLineIcon.people,
  'mail' || 'email' || 'mail_outline' => AppLineIcon.mail,
  'lock' || 'lock_outline' => AppLineIcon.lock,
  'visibility' => AppLineIcon.view,
  'visibility_off' => AppLineIcon.hide,
  'info' || 'info_outline' => AppLineIcon.info,
  'warning' || 'error' || 'error_outline' => AppLineIcon.alert,
  'qr_code' || 'qr_code_scanner' => AppLineIcon.qr,
  'camera_alt' || 'photo_camera' => AppLineIcon.camera,
  'image' || 'photo' => AppLineIcon.image,
  'download' || 'file_download' => AppLineIcon.download,
  'upload' || 'file_upload' => AppLineIcon.upload,
  'send' => AppLineIcon.send,
  'link' || 'open_in_new' => AppLineIcon.external,
  'bookmark' || 'bookmark_border' => AppLineIcon.bookmark,
  'schedule' || 'access_time' => AppLineIcon.clock,
  'book' || 'menu_book' => AppLineIcon.book,
  'chat' || 'message' || 'chat_bubble_outline' => AppLineIcon.message,
  'phone' || 'call' => AppLineIcon.phone,
  'logout' => AppLineIcon.logout,
  'shield' || 'security' => AppLineIcon.shield,
  'bolt' || 'flash_on' => AppLineIcon.bolt,
  'grid_view' || 'apps' => AppLineIcon.grid,
  'inbox' => AppLineIcon.inbox,
  'wifi_off' => AppLineIcon.wifiOff,
  'folder' => AppLineIcon.folder,
  'language' || 'public' => AppLineIcon.globe,
  'emoji_events' => AppLineIcon.trophy,
  _ => null,
};

AppLineIcon? lineIconOfNode(Object? node) {
  if (node is! Map<Object?, Object?>) return null;
  final map = KitModel.from(node);
  final icon = stringOrNullOf(map, 'icon');
  return switch (stringOf(map, 'type')) {
    'appLineIcon' => appLineIconByName(icon),
    'icon' => lineIconForMaterial(icon) ?? appLineIconByName(icon),
    _ => null,
  };
}
