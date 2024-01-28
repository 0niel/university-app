import 'package:filesize/filesize.dart';
import 'package:neon_files/l10n/localizations.dart';
import 'package:neon_framework/settings.dart';
import 'package:neon_framework/sort_box.dart';

class FilesOptions extends AppImplementationOptions {
  FilesOptions(super.storage) {
    super.categories = [
      generalCategory,
    ];
    super.options = [
      filesSortPropertyOption,
      filesSortBoxOrderOption,
      showHiddenFilesOption,
      showPreviewsOption,
      uploadQueueParallelism,
      downloadQueueParallelism,
      uploadSizeWarning,
      downloadSizeWarning,
    ];
  }

  final generalCategory = OptionsCategory(
    name: (context) => FilesLocalizations.of(context).general,
  );

  late final filesSortPropertyOption = SelectOption<FilesSortProperty>(
    storage: super.storage,
    category: generalCategory,
    key: FilesOptionKeys.sortProperty,
    label: (context) => FilesLocalizations.of(context).optionsFilesSortProperty,
    defaultValue: FilesSortProperty.name,
    values: {
      FilesSortProperty.name: (context) => FilesLocalizations.of(context).optionsFilesSortPropertyName,
      FilesSortProperty.modifiedDate: (context) => FilesLocalizations.of(context).optionsFilesSortPropertyModifiedDate,
      FilesSortProperty.size: (context) => FilesLocalizations.of(context).optionsFilesSortPropertySize,
    },
  );

  late final filesSortBoxOrderOption = SelectOption<SortBoxOrder>(
    storage: super.storage,
    category: generalCategory,
    key: FilesOptionKeys.sortOrder,
    label: (context) => FilesLocalizations.of(context).optionsFilesSortOrder,
    defaultValue: SortBoxOrder.ascending,
    values: sortBoxOrderOptionValues,
  );

  late final showHiddenFilesOption = ToggleOption(
    storage: super.storage,
    category: generalCategory,
    key: FilesOptionKeys.showHiddenFiles,
    label: (context) => FilesLocalizations.of(context).optionsShowHiddenFiles,
    defaultValue: false,
  );

  late final showPreviewsOption = ToggleOption(
    storage: super.storage,
    category: generalCategory,
    key: FilesOptionKeys.showPreviews,
    label: (context) => FilesLocalizations.of(context).optionsShowPreviews,
    defaultValue: true,
  );

  late final uploadQueueParallelism = SelectOption<int>(
    storage: storage,
    category: generalCategory,
    key: FilesOptionKeys.uploadQueueParallelism,
    label: (context) => FilesLocalizations.of(context).optionsUploadQueueParallelism,
    defaultValue: 4,
    values: {
      for (var i = 1; i <= 16; i = i * 2) ...{
        i: (_) => i.toString(),
      },
    },
  );

  late final downloadQueueParallelism = SelectOption<int>(
    storage: storage,
    category: generalCategory,
    key: FilesOptionKeys.downloadQueueParallelism,
    label: (context) => FilesLocalizations.of(context).optionsDownloadQueueParallelism,
    defaultValue: 4,
    values: {
      for (var i = 1; i <= 16; i = i * 2) ...{
        i: (_) => i.toString(),
      },
    },
  );

  late final _sizeWarningValues = <int?, LabelBuilder>{
    null: (context) => FilesLocalizations.of(context).optionsSizeWarningDisabled,
    for (var i in [
      1,
      10,
      100,
      1024,
      2 * 2024,
      6 * 1024,
      10 * 1024,
    ]) ...{
      _mb(i): (_) => filesize(_mb(i)),
    },
  };

  int _mb(int i) => i * 1024 * 1024;

  late final uploadSizeWarning = SelectOption<int?>(
    storage: storage,
    category: generalCategory,
    key: FilesOptionKeys.uploadSizeWarning,
    label: (context) => FilesLocalizations.of(context).optionsUploadSizeWarning,
    defaultValue: _mb(10),
    values: _sizeWarningValues,
  );

  late final downloadSizeWarning = SelectOption<int?>(
    storage: storage,
    category: generalCategory,
    key: FilesOptionKeys.downloadSizeWarning,
    label: (context) => FilesLocalizations.of(context).optionsDownloadSizeWarning,
    defaultValue: _mb(10),
    values: _sizeWarningValues,
  );
}

enum FilesOptionKeys implements Storable {
  sortProperty._('files-sort-property'),
  sortOrder._('files-sort-box-order'),
  showHiddenFiles._('show-hidden-files'),
  showPreviews._('show-previews'),
  uploadQueueParallelism._('upload-queue-parallelism'),
  downloadQueueParallelism._('download-queue-parallelism'),
  uploadSizeWarning._('upload-size-warning'),
  downloadSizeWarning._('download-size-warning');

  const FilesOptionKeys._(this.value);

  @override
  final String value;
}

enum FilesSortProperty {
  name,
  modifiedDate,
  size,
  isFolder,
}
