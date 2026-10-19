import 'package:app_ui/app_ui.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

AppLineIcon? lineIconForMaterial(String? name) => switch (name) {
  'add' || 'add_circle' || 'add_circle_outline' => .plus,
  'remove' || 'remove_circle_outline' => .minus,
  'close' || 'cancel' || 'clear' => .close,
  'check' || 'done' || 'check_circle' => .check,
  'edit' || 'create' || 'mode_edit' => .pencil,
  'delete' || 'delete_outline' => .trash,
  'share' || 'ios_share' => .share,
  'search' => .search,
  'favorite' || 'favorite_border' => .heart,
  'star' || 'star_border' || 'star_outline' => .star,
  'settings' => .settings,
  'notifications' || 'notifications_none' => .bell,
  'home' => .home,
  'calendar_today' || 'calendar_month' || 'event' => .calendar,
  'map' || 'place' || 'location_on' => .pin,
  'refresh' || 'sync' => .refresh,
  'arrow_forward' || 'arrow_right_alt' => .arrowRight,
  'arrow_back' || 'arrow_back_ios' || 'chevron_left' => .chevronL,
  'chevron_right' || 'arrow_forward_ios' => .chevronR,
  'expand_more' || 'keyboard_arrow_down' => .chevronD,
  'expand_less' || 'keyboard_arrow_up' => .chevronU,
  'more_vert' || 'more_horiz' => .more,
  'filter_list' || 'tune' => .filter,
  'person' || 'person_outline' || 'account_circle' => .user,
  'people' || 'group' => .people,
  'mail' || 'email' || 'mail_outline' => .mail,
  'lock' || 'lock_outline' => .lock,
  'visibility' => .view,
  'visibility_off' => .hide,
  'info' || 'info_outline' => .info,
  'warning' || 'error' || 'error_outline' => .alert,
  'qr_code' || 'qr_code_scanner' => .qr,
  'camera_alt' || 'photo_camera' => .camera,
  'image' || 'photo' => .image,
  'download' || 'file_download' => .download,
  'upload' || 'file_upload' => .upload,
  'send' => .send,
  'link' || 'open_in_new' => .external,
  'bookmark' || 'bookmark_border' => .bookmark,
  'schedule' || 'access_time' => .clock,
  'book' || 'menu_book' => .book,
  'chat' || 'message' || 'chat_bubble_outline' => .message,
  'phone' || 'call' => .phone,
  'logout' => .logout,
  'shield' || 'security' => .shield,
  'bolt' || 'flash_on' => .bolt,
  'grid_view' || 'apps' => .grid,
  'inbox' => .inbox,
  'wifi_off' => .wifiOff,
  'folder' => .folder,
  'language' || 'public' => .globe,
  'emoji_events' => .trophy,
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
