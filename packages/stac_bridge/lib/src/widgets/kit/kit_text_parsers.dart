import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

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
  'center' => TextAlign.center,
  'end' || 'right' => TextAlign.end,
  'start' || 'left' => TextAlign.start,
  'justify' => TextAlign.justify,
  _ => null,
};

class StacAppTextParser extends StacParser<KitModel> {
  const StacAppTextParser();

  @override
  String get type => 'appText';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final variant = stringOrNullOf(model, 'variant');
    final data = stringOf(model, 'data', stringOf(model, 'text'));
    final maxLines = intOf(model, 'maxLines');
    return Text(
      variant == 'overline' || boolOf(model, 'uppercase')
          ? data.toUpperCase()
          : data,
      style: appTextStyleOf(variant).copyWith(
        color:
            colorOf(context, model, 'color') ??
            (variant == 'overline' || variant == 'caption'
                ? context.colors.muted
                : context.colors.ink),
      ),
      textAlign: textAlignOf(stringOrNullOf(model, 'align')),
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
    );
  }
}

class StacAppOverlineParser extends StacParser<KitModel> {
  const StacAppOverlineParser();

  @override
  String get type => 'appOverline';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppOverline(
    stringOf(model, 'label', stringOf(model, 'text')),
    topPadding: doubleOr(model, 'topPadding', 22),
    bottomPadding: doubleOr(model, 'bottomPadding', 10),
    color: colorOf(context, model, 'color'),
  );
}

class StacAppSectionTitleParser extends StacParser<KitModel> {
  const StacAppSectionTitleParser();

  @override
  String get type => 'appSectionTitle';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppSectionTitle(
    title: stringOf(model, 'title'),
    subtitle: stringOrNullOf(model, 'subtitle'),
    action: stringOrNullOf(model, 'action'),
    meta: stringOrNullOf(model, 'meta'),
    topMargin: doubleOr(model, 'topMargin', 26),
    bottomPadding: doubleOr(model, 'bottomPadding', 12),
    onActionTap: actionOf(context, model, const ['onActionTap', 'onAction']),
  );
}

class StacAppExpandableTextParser extends StacParser<KitModel> {
  const StacAppExpandableTextParser();

  @override
  String get type => 'appExpandableText';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppExpandableText(
    text: stringOf(model, 'text', stringOf(model, 'data')),
    expandLabel: stringOf(
      model,
      'expandLabel',
      kitText(context, ru: 'Показать ещё', en: 'Show more'),
    ),
    collapseLabel: stringOf(
      model,
      'collapseLabel',
      kitText(context, ru: 'Свернуть', en: 'Show less'),
    ),
    collapsedMaxLines: intOf(model, 'maxLines') ?? 4,
    style: appTextStyleOf(stringOrNullOf(model, 'variant')).copyWith(
      color: colorOf(context, model, 'color') ?? context.colors.ink,
    ),
  );
}
