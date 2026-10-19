import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

export 'stac_app_expandable_text_parser.dart';
export 'stac_app_overline_parser.dart';
export 'stac_app_section_title_parser.dart';
export 'stac_app_text_parser.dart';

TextStyle appTextStyleOf(String? variant) => switch (variant) {
  'display' => AppText.display,
  'displaySmall' => AppText.displaySmall,
  'sectionLarge' || 'title' => AppText.sectionLarge,
  'section' => AppText.section,
  'sectionSmall' => AppText.sectionSmall,
  'pageTitle' => AppText.title,
  'heading' => AppText.heading,
  'headline' => AppText.headline,
  'headlineStrong' => AppText.headlineStrong,
  'cell' => AppText.cell,
  'bodyStrong' => AppText.bodyStrong,
  'bodyLarge' => AppText.bodyLarge,
  'paragraph' => AppText.paragraph,
  'lead' => AppText.lead,
  'compact' => AppText.compact,
  'label' => AppText.label,
  'labelStrong' => AppText.labelStrong,
  'subtext' => AppText.subtext,
  'subtextStrong' => AppText.subtextStrong,
  'caption' => AppText.caption,
  'captionStrong' => AppText.captionStrong,
  'overline' => AppText.overline,
  'micro' => AppText.micro,
  'metric' => AppText.metric,
  'code' => AppText.code,
  'time' => AppText.time,
  _ => AppText.body,
};

TextAlign? textAlignOf(String? name) => switch (name) {
  'center' => .center,
  'end' || 'right' => .end,
  'start' || 'left' => .start,
  'justify' => .justify,
  _ => null,
};
