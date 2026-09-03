import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/services/models/service_entry.dart';
import 'package:rtu_mirea_app/services/models/service_model.dart';
import 'package:service_catalog_repository/service_catalog_repository.dart';

ServiceModel catalogServiceTile(
  BuildContext context,
  ServiceCatalogEntry entry,
) => ServiceModel(
  title: entry.title,
  icon: _iconFor(entry.iconKey),
  color: catalogServiceTone(context, entry),
  url: entry.url,
);

ServiceEntry catalogServiceEntry(
  BuildContext context,
  ServiceCatalogEntry entry,
) {
  final description = entry.description.trim();
  return ServiceEntry(
    model: catalogServiceTile(context, entry),
    subtitle: description.isEmpty
        ? context.l10n.serviceExternalSub
        : description,
    tone: catalogServiceTone(context, entry),
  );
}

Color catalogServiceTone(BuildContext context, ServiceCatalogEntry entry) {
  final colors = context.colors;
  final tones = [colors.lecture, colors.practice, colors.lab, colors.exam];
  return tones[entry.id.hashCode.abs() % tones.length];
}

AppLineIcon _iconFor(String iconKey) => switch (iconKey) {
  'business' || 'work' => AppLineIcon.bag,
  'computer' => AppLineIcon.grid,
  'dormitory' => AppLineIcon.home,
  'download' => AppLineIcon.download,
  'help' => AppLineIcon.info,
  'idea' => AppLineIcon.spark,
  'library' => AppLineIcon.book,
  'payments' => AppLineIcon.card,
  'rocket' => AppLineIcon.bolt,
  'shield' => AppLineIcon.shield,
  'support' => AppLineIcon.message,
  _ => AppLineIcon.globe,
};
