import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

enum SourceType { official, telegram, community, rss, vk, app }

class _SourceMeta {
  const _SourceMeta({required this.color, required this.icon});
  final Color color;
  final IconData icon;
}

const _kFallbackMeta = _SourceMeta(
  color: Color(0xFF1FB872),
  icon: Icons.auto_awesome_rounded,
);

const Map<SourceType, _SourceMeta> _kMeta = {
  SourceType.official: _SourceMeta(
    color: Color(0xFF2F7AFF),
    icon: Icons.verified_user_rounded,
  ),
  SourceType.telegram: _SourceMeta(
    color: Color(0xFF229ED9),
    icon: Icons.send_rounded,
  ),
  SourceType.community: _SourceMeta(
    color: Color(0xFFA45CFF),
    icon: Icons.people_rounded,
  ),
  SourceType.rss: _SourceMeta(
    color: Color(0xFFFF8A2F),
    icon: Icons.rss_feed_rounded,
  ),
  SourceType.vk: _SourceMeta(
    color: Color(0xFF0077FF),
    icon: Icons.message_rounded,
  ),
  SourceType.app: _SourceMeta(
    color: Color(0xFF1FB872),
    icon: Icons.auto_awesome_rounded,
  ),
};

/// Design: "SourceBadge" · Источники новостей — screens-feed.jsx.
///
/// Small badge that shows where a news item came from.
///
/// [size] `sm` (default) renders icon + text inline with transparent bg.
/// `md` renders a pill with a tinted background.
class AppSourceBadge extends StatelessWidget {
  const AppSourceBadge({
    required this.type,
    required this.source,
    super.key,
    this.size = SourceBadgeSize.sm,
  });

  final SourceType type;
  final String source;
  final SourceBadgeSize size;

  @override
  Widget build(BuildContext context) {
    final meta = _kMeta[type] ?? _kFallbackMeta;
    final isMd = size == SourceBadgeSize.md;

    return Container(
      padding: isMd ? const EdgeInsets.fromLTRB(4, 4, 8, 4) : EdgeInsets.zero,
      decoration: isMd
          ? BoxDecoration(
              color: meta.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            )
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: meta.color,
              shape: BoxShape.circle,
            ),
            child: Icon(meta.icon, size: 12, color: Colors.white),
          ),
          const SizedBox(width: 6),
          Text(
            source,
            style: AppText.caption.copyWith(
              color: isMd ? meta.color : Theme.of(context).colors.deactive,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

enum SourceBadgeSize { sm, md }
