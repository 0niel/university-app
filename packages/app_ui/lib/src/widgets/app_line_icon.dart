// SVG path literals intentionally use adjacent strings for readable segments.
// ignore_for_file: missing_whitespace_between_adjacent_strings

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppLineIcon {
  user('<circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 4-6 8-6s8 2 8 6"/>'),

  lock(
    '<rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 018 0v4"/>',
  ),

  hide(
    '<path d="M2 12s3.5-7 10-7c3 0 5.5 1.5 7.3 3"/><path d="M22 12s-3.5 7-10 7c-2 0-3.8-.7-5.4-1.8"/><path d="M3 3l18 18"/><circle cx="12" cy="12" r="3"/>',
  ),

  view(
    '<path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7-10-7-10-7z"/><circle cx="12" cy="12" r="3"/>',
  ),

  arrowRight('<path d="M5 12h14"/><path d="M13 6l6 6-6 6"/>'),

  mail(
    '<rect x="3" y="5" width="18" height="14" rx="2"/><path d="M4 7l8 6 8-6"/>',
  ),
  at(
    '<circle cx="12" cy="12" r="4"/>'
    '<path d="M16 8v5a3 3 0 006 0v-1a10 10 0 10-3.9 7.9"/>',
  ),

  close('<path d="M6 6l12 12M18 6L6 18"/>'),

  home(
    '<path d="M3 11.5L12 4l9 7.5"/>'
    '<path d="M5 10v9a1 1 0 001 1h4v-6h4v6h4a1 1 0 001-1v-9"/>',
  ),
  calendar(
    '<rect x="3.5" y="5" width="17" height="15" rx="2.5"/>'
    '<path d="M3.5 9.5h17M8 3v4M16 3v4"/>',
  ),
  map(
    '<path d="M9 4l-6 2v14l6-2 6 2 6-2V4l-6 2-6-2z"/><path d="M9 4v14M15 6v14"/>',
  ),
  grid(
    '<rect x="3.5" y="3.5" width="7" height="7" rx="1.4"/>'
    '<rect x="13.5" y="3.5" width="7" height="7" rx="1.4"/>'
    '<rect x="3.5" y="13.5" width="7" height="7" rx="1.4"/>'
    '<rect x="13.5" y="13.5" width="7" height="7" rx="1.4"/>',
  ),
  services(
    '<rect x="3.5" y="3.5" width="7" height="7" rx="2"/>'
    '<circle cx="17" cy="7" r="3.5"/>'
    '<circle cx="7" cy="17" r="3.5"/>'
    '<path d="M14 14h6v6h-6z"/>',
  ),
  search('<circle cx="11" cy="11" r="6.5"/><path d="M20 20l-4.2-4.2"/>'),
  bell(
    '<path d="M6 16V11a6 6 0 0112 0v5l1.5 2H4.5L6 16z"/>'
    '<path d="M10 20a2 2 0 004 0"/>',
  ),
  settings(
    '<circle cx="12" cy="12" r="3"/>'
    '<path d="M19.4 15a1.7 1.7 0 00.3 1.8l.1.1a2 2 0 11-2.8 2.8l-.1-.1a1.7 '
    '1.7 0 00-1.8-.3 1.7 1.7 0 00-1 1.5V21a2 2 0 11-4 0v-.1a1.7 1.7 0 '
    '00-1.1-1.5 1.7 1.7 0 00-1.8.3l-.1.1a2 2 0 11-2.8-2.8l.1-.1a1.7 1.7 0 '
    '00.3-1.8 1.7 1.7 0 00-1.5-1H3a2 2 0 110-4h.1A1.7 1.7 0 004.6 9a1.7 1.7 '
    '0 00-.3-1.8l-.1-.1a2 2 0 112.8-2.8l.1.1a1.7 1.7 0 001.8.3H9a1.7 1.7 0 '
    '001-1.5V3a2 2 0 114 0v.1a1.7 1.7 0 001 1.5 1.7 1.7 0 001.8-.3l.1-.1a2 2 '
    '0 112.8 2.8l-.1.1a1.7 1.7 0 00-.3 1.8V9a1.7 1.7 0 001.5 1H21a2 2 0 110 '
    '4h-.1a1.7 1.7 0 00-1.5 1z"/>',
  ),
  chevronR('<path d="M9 6l6 6-6 6"/>'),
  chevronL('<path d="M15 6l-6 6 6 6"/>'),
  chevronD('<path d="M6 9l6 6 6-6"/>'),
  chevronU('<path d="M6 15l6-6 6 6"/>'),
  plus('<path d="M12 5v14M5 12h14"/>'),
  minus('<path d="M5 12h14"/>'),
  filter('<path d="M4 5h16M7 12h10M10 19h4"/>'),
  more(
    '<circle cx="5" cy="12" r="1.4" fill="currentColor"/>'
    '<circle cx="12" cy="12" r="1.4" fill="currentColor"/>'
    '<circle cx="19" cy="12" r="1.4" fill="currentColor"/>',
  ),

  book(
    '<path d="M4 19.5v-15A2.5 2.5 0 016.5 2H19a1 1 0 011 1v18a1 1 0 01-1 '
    '1H6.5a1 1 0 010-5H20"/>',
  ),
  flask(
    '<path d="M9 3h6M10 3v6l-5 9a2 2 0 001.8 3h10.4a2 2 0 001.8-3l-5-9V3"/>'
    '<path d="M7.5 15h9"/>',
  ),
  pin(
    '<path d="M12 22s7-7.2 7-12a7 7 0 10-14 0c0 4.8 7 12 7 12z"/>'
    '<circle cx="12" cy="10" r="2.5"/>',
  ),
  heart(
    '<path d="M12 20s-7-4.6-7-10a4 4 0 017-2.7A4 4 0 0119 10c0 5.4-7 10-7 10z"/>',
  ),
  star(
    '<path d="M12 3l2.7 5.6 6.2.9-4.5 4.3 1.1 6.1L12 17l-5.5 2.9 1.1-6.1L3 '
    '9.5l6.2-.9L12 3z"/>',
  ),
  message(
    '<path d="M21 12c0 4.4-4 8-9 8-1.4 0-2.8-.3-4-.8L3 21l1-4.5C3.4 15.3 3 '
    '13.7 3 12c0-4.4 4-8 9-8s9 3.6 9 8z"/>',
  ),
  share(
    '<circle cx="6" cy="12" r="2.5"/><circle cx="18" cy="6" r="2.5"/>'
    '<circle cx="18" cy="18" r="2.5"/><path d="M8.2 11l7.6-4M8.2 13l7.6 4"/>',
  ),
  clock('<circle cx="12" cy="12" r="8.5"/><path d="M12 7v5l3 2"/>'),
  check('<path d="M5 12l4.5 4.5L19 7"/>'),
  shield('<path d="M12 22s8-3 8-10V5l-8-3-8 3v7c0 7 8 10 8 10z"/>'),
  people(
    '<circle cx="9" cy="9" r="3.5"/><circle cx="17" cy="10" r="2.5"/>'
    '<path d="M3 19c0-3.3 2.7-5 6-5s6 1.7 6 5"/>'
    '<path d="M15 19c0-2.5 1.5-4 3.5-4S22 16.5 22 19"/>',
  ),
  bolt('<path d="M13 2L4 14h7l-1 8 9-12h-7l1-8z"/>'),
  qr(
    '<rect x="3.5" y="3.5" width="6" height="6" rx="1"/>'
    '<rect x="14.5" y="3.5" width="6" height="6" rx="1"/>'
    '<rect x="3.5" y="14.5" width="6" height="6" rx="1"/>'
    '<path d="M14.5 14.5h2v2M19 14.5v2h-2.5M14.5 19h2v1.5M19 20.5h1.5"/>',
  ),
  mic(
    '<rect x="9" y="3" width="6" height="12" rx="3"/>'
    '<path d="M5 11a7 7 0 0014 0M12 18v3"/>',
  ),
  pencil(
    '<path d="M12 20h9"/>'
    '<path d="M16.5 3.5a2.1 2.1 0 113 3L7 19l-4 1 1-4 12.5-12.5z"/>',
  ),
  spark(
    '<path d="M12 3v6M12 15v6M3 12h6M15 12h6M5 5l4 4M15 15l4 4M5 19l4-4M15 '
    '9l4-4"/>',
  ),
  refresh('<path d="M21 12a9 9 0 11-3-6.7"/><path d="M21 4v5h-5"/>'),
  bookmark('<path d="M5 21V5a2 2 0 012-2h10a2 2 0 012 2v16l-7-4-7 4z"/>'),
  alert('<path d="M12 3l9 16H3z"/><path d="M12 10v4M12 17v.5"/>'),
  download('<path d="M12 3v12M7 11l5 5 5-5"/><path d="M4 19h16"/>'),
  trash(
    '<path d="M3 6h18M8 6V4a1 1 0 011-1h6a1 1 0 011 1v2M5 6l1 14a2 2 0 002 '
    '2h8a2 2 0 002-2l1-14"/>',
  ),
  trophy(
    '<path d="M7 4h10v4a5 5 0 01-10 0z"/>'
    '<path d="M7 5H4v2a3 3 0 003 3M17 5h3v2a3 3 0 01-3 3M9 19h6M12 13v6"/>',
  ),

  swipe(
    '<path d="M9 11V5a1.5 1.5 0 013 0v6"/>'
    '<path d="M12 11V9a1.5 1.5 0 013 0v3a1.5 1.5 0 013 0v1c0 4-2 7-6 7-3 '
    '0-4.5-1.5-6-4l-1.6-2.8a1.4 1.4 0 012.2-1.7L9 14"/>'
    '<path d="M4 4L2 6l2 2M20 4l2 2-2 2"/>',
  ),

  wifiOff(
    '<path d="M2 8.8a15 15 0 014.2-2.6"/>'
    '<path d="M22 8.8A15 15 0 0010.7 5"/>'
    '<path d="M5 12.9a10 10 0 015.2-2.7"/>'
    '<path d="M19 12.9a10 10 0 00-2-1.5"/>'
    '<path d="M8.5 16.4a5 5 0 017 0"/>'
    '<path d="M12 20h.01"/><path d="M2 2l20 20"/>',
  ),

  inbox(
    '<path d="M22 12h-6l-2 3h-4l-2-3H2"/>'
    '<path d="M5.45 5.11L2 12v6a2 2 0 002 2h16a2 2 0 002-2v-6l-3.45-6.89A2 '
    '2 0 0016.76 4H7.24a2 2 0 00-1.79 1.11z"/>',
  ),

  door(
    '<rect x="5" y="2.5" width="14" height="19" rx="1.5"/>'
    '<circle cx="14.5" cy="12" r="1" fill="currentColor"/>',
  ),

  chart(
    '<path d="M4 20V10M12 20V4M20 20v-7"/><path d="M3 20.5h18"/>',
  ),

  bag(
    '<path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/>'
    '<path d="M3 6h18"/><path d="M16 10a4 4 0 01-8 0"/>',
  ),

  card(
    '<rect x="2.5" y="5" width="19" height="14" rx="2.2"/>'
    '<path d="M2.5 10h19"/>',
  ),

  clipboard(
    '<rect x="6" y="4" width="12" height="16" rx="2"/>'
    '<path d="M9 4a1 1 0 011-1h4a1 1 0 011 1v1H9z"/>'
    '<path d="M9 10h6M9 14h6"/>',
  ),

  info(
    '<circle cx="12" cy="12" r="9"/><path d="M12 11v6"/>'
    '<circle cx="12" cy="8" r="1" fill="currentColor"/>',
  ),

  camera(
    '<rect x="3" y="7" width="18" height="13" rx="2"/>'
    '<path d="M8 7l1.5-3h5L16 7"/><circle cx="12" cy="13.5" r="3.5"/>',
  ),

  image(
    '<rect x="3" y="3" width="18" height="18" rx="2"/>'
    '<circle cx="8.5" cy="8.5" r="1.5" fill="currentColor"/>'
    '<path d="M21 15l-5-5-9 9"/>',
  ),

  folder(
    '<path d="M3 7a2 2 0 012-2h4l2 2h8a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 '
    '01-2-2V7z"/>',
  ),
  globe(
    '<circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c3 3 4 6 4 9s-1 6-4 9c-3-3-4-6-4-9s1-6 4-9z"/>',
  ),
  fingerprint(
    '<path d="M7 10a5 5 0 0110 0c0 5-1 8-3 11M4 12v-2a8 8 0 0116 0v2M8 13c0 4-1 6-2 8M12 9a2 2 0 012 2c0 4-.5 7-2 10M10 12c0 3-.5 5-1.5 7"/>',
  ),
  contactless(
    '<path d="M7 8a6 6 0 010 8M11 5a10 10 0 010 14M15 3a13 13 0 010 18"/>',
  ),
  palette(
    '<path d="M12 3a9 9 0 100 18h1.5a2 2 0 001.5-3.3 2 2 0 011.5-3.3H18A3 3 0 0021 11c0-4.4-4-8-9-8z"/><circle cx="7.5" cy="10" r="1"/><circle cx="10" cy="6.5" r="1"/><circle cx="15" cy="7" r="1"/>',
  ),
  smile(
    '<circle cx="12" cy="12" r="9"/><path d="M8 14c1 2 2.3 3 4 3s3-1 4-3"/><circle cx="9" cy="9" r="1" fill="currentColor"/><circle cx="15" cy="9" r="1" fill="currentColor"/>',
  ),
  database(
    '<ellipse cx="12" cy="5.5" rx="8" ry="3"/><path d="M4 5.5v6c0 1.7 3.6 3 8 3s8-1.3 8-3v-6M4 11.5v6c0 1.7 3.6 3 8 3s8-1.3 8-3v-6"/>',
  ),
  logout(
    '<path d="M10 4H5a2 2 0 00-2 2v12a2 2 0 002 2h5M14 8l4 4-4 4M8 12h10"/>',
  ),
  moon('<path d="M20 15.5A8.5 8.5 0 018.5 4 8.5 8.5 0 1020 15.5z"/>'),
  focus(
    '<path d="M8 3H5a2 2 0 00-2 2v3M16 3h3a2 2 0 012 2v3M21 16v3a2 2 0 01-2 2h-3M8 21H5a2 2 0 01-2-2v-3"/><circle cx="12" cy="12" r="3"/>',
  ),
  tune(
    '<path d="M4 7h7M15 7h5M4 17h5M13 17h7"/>'
    '<circle cx="13" cy="7" r="2"/><circle cx="11" cy="17" r="2"/>',
  ),
  phone(
    '<path d="M7 3h3l1.5 4-2 1.5a15 15 0 006 6L17 12.5l4 1.5v3c0 2-1 4-4 4C9.3 21 3 14.7 3 7c0-3 2-4 4-4z"/>',
  ),
  send(
    '<path d="M3 11.5L21 3l-6.5 18-3.2-7.1L3 11.5z"/>'
    '<path d="M11.3 13.9L21 3"/>',
  ),
  upload('<path d="M12 21V7M7 12l5-5 5 5"/><path d="M4 4h16"/>'),
  external(
    '<path d="M13 4h7v7M20 4l-9 9"/>'
    '<path d="M18 14v5a2 2 0 01-2 2H5a2 2 0 01-2-2V8a2 2 0 012-2h5"/>',
  ),
  key(
    '<circle cx="8" cy="12" r="4"/><path d="M12 12h9M17 12v3M20 12v2"/>',
  ),
  tag('<path d="M3 4h8l10 10-7 7L4 11V4z"/><circle cx="8" cy="8" r="1"/>'),
  swap('<path d="M4 7h14M14 3l4 4-4 4M20 17H6M10 13l-4 4 4 4"/>'),
  cloudOff(
    '<path d="M7 18H6a4 4 0 01-.7-7.9A7 7 0 0117.7 8"/>'
    '<path d="M18 18h1a3 3 0 00.8-5.9M3 3l18 18"/>',
  ),
  device(
    '<rect x="4" y="3" width="16" height="12" rx="2"/>'
    '<path d="M8 21h8M12 15v6"/>',
  ),
  box(
    '<path d="M4 7l8-4 8 4-8 4-8-4z"/>'
    '<path d="M4 7v10l8 4 8-4V7M12 11v10"/>',
  ),
  shirt(
    '<path d="M8 4l4 2 4-2 5 4-3 4-2-2v11H8V10l-2 2-3-4 5-4z"/>',
  ),
  imageOff(
    '<path d="M3.6 3.6A2 2 0 003 5v14a2 2 0 002 2h14a2 2 0 001.4-.6"/>'
    '<path d="M21 15V5a2 2 0 00-2-2H9"/>'
    '<path d="M3 17l5-5 2.5 2.5"/><path d="M18.5 12.5L17 11"/>'
    '<path d="M2 2l20 20"/>',
  ),
  video(
    '<rect x="3" y="6" width="13" height="12" rx="2"/>'
    '<path d="M16 10l5-3v10l-5-3"/>',
  ),
  face(
    '<path d="M4 8V6a2 2 0 012-2h2"/><path d="M16 4h2a2 2 0 012 2v2"/>'
    '<path d="M20 16v2a2 2 0 01-2 2h-2"/><path d="M8 20H6a2 2 0 01-2-2v-2"/>'
    '<path d="M9 10v1.5"/><path d="M15 10v1.5"/>'
    '<path d="M9.5 15c.7.7 1.6 1 2.5 1s1.8-.3 2.5-1"/>',
  ),
  school(
    '<path d="M3 9l9-5 9 5-9 5-9-5z"/>'
    '<path d="M7 12v4c3 2 7 2 10 0v-4M21 9v6"/>',
  ),
  battery(
    '<rect x="3" y="7" width="16" height="10" rx="2"/>'
    '<path d="M21 10v4M7 10v4"/>',
  );

  const AppLineIcon(this.body);

  final String body;
}

class AppLineIconWidget extends StatelessWidget {
  const AppLineIconWidget(
    this.icon, {
    super.key,
    this.size = 22,
    this.color,
    this.strokeWidth = 2,
  });

  final AppLineIcon icon;

  final double size;

  final Color? color;

  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final resolved =
        color ?? IconTheme.of(context).color ?? Theme.of(context).colors.active;
    final svg =
        '<svg xmlns="http://www.w3.org/2000/svg" width="$size" height="$size" '
        'viewBox="0 0 24 24" fill="none" stroke="#000000" '
        'stroke-width="$strokeWidth" stroke-linecap="round" '
        'stroke-linejoin="round">${icon.body}</svg>';

    return Align(
      widthFactor: 1,
      heightFactor: 1,
      child: SvgPicture.string(
        svg,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(resolved, BlendMode.srcIn),
      ),
    );
  }
}
