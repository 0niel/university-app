import 'package:rtu_mirea_app/map/data/file_map_data_cache.dart';
import 'package:rtu_mirea_app/map/data/map_data_cache.dart';

export 'file_map_data_cache.dart';

MapDataCache createMapDataCache() {
  const legacy = PreferencesMapDataCache();
  return FileMapDataCache(
    legacyCache: legacy,
    onMigrated: legacy.removeMigrated,
  );
}
