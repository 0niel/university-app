import 'package:nextcloud/src/webdav/client.dart';
import 'package:nextcloud/src/webdav/path_uri.dart';
import 'package:nextcloud/src/webdav/props.dart';
import 'package:nextcloud/src/webdav/webdav.dart';

// ignore: public_member_api_docs
extension WebDavMultistatusFile on WebDavMultistatus {
  /// Convert the [WebDavMultistatus] into a [WebDavFile] for easier handling
  List<WebDavFile> toWebDavFiles() =>
      responses.where((response) => response.href != null).map((response) => WebDavFile(response: response)).toList();
}

/// WebDavFile class
class WebDavFile {
  /// Creates a new WebDavFile object with the given path
  WebDavFile({
    required WebDavResponse response,
  }) : _response = response;

  final WebDavResponse _response;

  /// Get the props of the file
  late final WebDavProp props = _response.propstats.singleWhere((propstat) => propstat.status.contains('200')).prop;

  /// The path of file
  late final PathUri path = () {
    final href = PathUri.parse(Uri.decodeFull(_response.href!));
    return PathUri(
      isAbsolute: false,
      isDirectory: href.isDirectory,
      pathSegments: href.pathSegments.sublist(webdavBase.pathSegments.length),
    );
  }();

  /// The fileid namespaced by the instance id, globally unique
  late final String? id = props.ocid;

  /// The unique id for the file within the instance
  late final String? fileId = props.ocfileid;

  /// Whether this is a collection resource type
  late final bool? isCollection = props.davresourcetype != null ? props.davresourcetype!.collection != null : null;

  /// Mime-type of the file
  late final String? mimeType = props.davgetcontenttype;

  /// ETag of the file
  late final String? etag = props.davgetetag;

  /// File content length or folder size
  late final int? size = props.ocsize ?? props.davgetcontentlength;

  /// The user id of the owner of a shared file
  late final String? ownerId = props.ocownerid;

  /// The display name of the owner of a shared file
  late final String? ownerDisplay = props.ocownerdisplayname;

  /// Share note
  late final String? note = props.ncnote;

  /// Last modified date of the file
  late final DateTime? lastModified = () {
    if (props.davgetlastmodified != null) {
      return webdavDateFormat.parseUtc(props.davgetlastmodified!);
    }
    return null;
  }();

  /// Upload date of the file
  late final DateTime? uploadedDate =
      props.ncuploadtime != null ? DateTime.fromMillisecondsSinceEpoch(props.ncuploadtime! * 1000, isUtc: true) : null;

  /// Creation date of the file as provided by uploader
  late final DateTime? createdDate = props.nccreationtime != null
      ? DateTime.fromMillisecondsSinceEpoch(props.nccreationtime! * 1000, isUtc: true)
      : null;

  /// Whether this file is marked as favorite
  late final bool? favorite = props.ocfavorite == null ? null : props.ocfavorite == 1;

  /// Whether this file has a preview image
  late final bool? hasPreview = props.nchaspreview;

  /// Returns the decoded name of the file / folder without the whole path
  late final String name = path.name;

  /// Whether the file is hidden.
  late final bool isHidden = name.startsWith('.');

  /// Whether the file is a directory
  late final bool isDirectory = (isCollection ?? false) || path.isDirectory;
}
