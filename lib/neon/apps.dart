import 'package:built_collection/built_collection.dart';
import 'package:neon_dashboard/neon_dashboard.dart';
import 'package:neon_files/neon_files.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_news/neon_news.dart';
import 'package:neon_notes/neon_notes.dart';
import 'package:neon_notifications/neon_notifications.dart';

/// The collection of clients enabled for the Neon app.
final BuiltSet<AppImplementation> appImplementations = BuiltSet({
  DashboardApp(),
  FilesApp(),
  NewsApp(),
  NotesApp(),
  NotificationsApp(),
});
