import 'localizations.dart';

/// The translations for English (`en`).
class FilesLocalizationsEn extends FilesLocalizations {
  FilesLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionRename => 'Rename';

  @override
  String get actionMove => 'Move';

  @override
  String get actionCopy => 'Copy';

  @override
  String get actionShare => 'Share';

  @override
  String get errorUnableToOpenFile => 'Unable to open the file';

  @override
  String get general => 'General';

  @override
  String goToPath(String path) {
    return 'Go to /$path';
  }

  @override
  String get uploadFiles => 'Upload files';

  @override
  String get uploadImages => 'Upload images';

  @override
  String get uploadCamera => 'Upload from camera';

  @override
  String uploadConfirmSizeWarning(String warningSize, String actualSize) {
    return 'Are you sure you want to upload a file that is bigger than $warningSize ($actualSize)?';
  }

  @override
  String downloadConfirmSizeWarning(String warningSize, String actualSize) {
    return 'Are you sure you want to download a file that is bigger than $warningSize ($actualSize)?';
  }

  @override
  String get actionDeleteTitle => 'Permanently delete?';

  @override
  String get filesChooseCreate => 'Add to Nextcloud';

  @override
  String get folderCreate => 'Create folder';

  @override
  String get folderName => 'Folder name';

  @override
  String get folderRename => 'Rename folder';

  @override
  String get folderChoose => 'Choose folder';

  @override
  String folderDeleteConfirm(String name) {
    return 'Are you sure you want to delete the folder \'$name\'?';
  }

  @override
  String get fileRename => 'Rename file';

  @override
  String fileDeleteConfirm(String name) {
    return 'Are you sure you want to delete the file \'$name\'?';
  }

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get details => 'Details';

  @override
  String get detailsFileName => 'File name';

  @override
  String get detailsFolderName => 'Folder name';

  @override
  String get detailsParentFolder => 'Parent folder';

  @override
  String get detailsFileSize => 'File size';

  @override
  String get detailsFolderSize => 'Folder size';

  @override
  String get detailsLastModified => 'Last modified';

  @override
  String get detailsIsFavorite => 'Is favorite';

  @override
  String get optionsFilesSortProperty => 'How to sort files';

  @override
  String get optionsFilesSortPropertyName => 'Name';

  @override
  String get optionsFilesSortPropertyModifiedDate => 'Last modified';

  @override
  String get optionsFilesSortPropertySize => 'Size';

  @override
  String get optionsFilesSortOrder => 'Sort order of files';

  @override
  String get optionsShowHiddenFiles => 'Show hidden files';

  @override
  String get optionsShowPreviews => 'Show previews for files';

  @override
  String get optionsUploadQueueParallelism => 'Upload queue parallelism';

  @override
  String get optionsDownloadQueueParallelism => 'Download queue parallelism';

  @override
  String get optionsUploadSizeWarning => 'Upload size warning';

  @override
  String get optionsDownloadSizeWarning => 'Download size warning';

  @override
  String get optionsSizeWarningDisabled => 'Disabled';
}
