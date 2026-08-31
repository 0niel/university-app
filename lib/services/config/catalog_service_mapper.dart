import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/services/models/service_model.dart';
import 'package:service_catalog_repository/service_catalog_repository.dart';

ServiceModel catalogServiceTile(
  BuildContext context,
  ServiceCatalogEntry entry,
) => .new(
  title: entry.title,
  icon: _iconFor(entry.iconKey),
  color: context.ninja.subjectBaseColor(entry.id),
  url: entry.url,
);

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
