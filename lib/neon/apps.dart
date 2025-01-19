import 'package:built_collection/built_collection.dart';
import 'package:files_app/files_app.dart';
import 'package:neon_framework/models.dart';

/// The collection of clients enabled for the Neon app.
final BuiltSet<AppImplementation> appImplementations = BuiltSet({
  FilesApp(),
});
