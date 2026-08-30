import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/community/models/event_category.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

const Map<EventCategory, String> kEventCategoryEmojis = {
  EventCategory.all: '🎉',
  EventCategory.career: '💼',
  EventCategory.sport: '🏀',
  EventCategory.art: '🎨',
  EventCategory.science: '🔬',
  EventCategory.other: '🎉',
};

String eventCategoryEmoji(EventCategory category) =>
    kEventCategoryEmojis[category] ?? '🎉';

Color eventCategoryColor(NinjaColors colors, EventCategory category) =>
    switch (category) {
      .all || .career => colors.brand,
      .sport => colors.scarlet,
      .art => colors.orange,
      .science => colors.green,
      .other => colors.amber,
    };

String eventCategoryLabel(AppLocalizations l10n, EventCategory category) =>
    switch (category) {
      .all => l10n.eventsFilterAll,
      .career => l10n.eventsCategoryCareer,
      .sport => l10n.eventsCategorySport,
      .art => l10n.eventsCategoryArt,
      .science => l10n.eventsCategorySci,
      .other => l10n.eventsCategoryOther,
    };
