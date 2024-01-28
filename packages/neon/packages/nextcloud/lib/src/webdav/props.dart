// ignore_for_file: public_member_api_docs
// coverage:ignore-file
import 'package:meta/meta.dart';
import 'package:nextcloud/src/webdav/webdav.dart';
import 'package:xml/xml.dart';
import 'package:xml_annotation/xml_annotation.dart' as annotation;
part 'props.g.dart';

@immutable
@annotation.XmlSerializable(createMixin: true)
@annotation.XmlRootElement(name: 'prop', namespace: namespaceDav)
class WebDavPropWithoutValues with _$WebDavPropWithoutValuesXmlSerializableMixin {
  const WebDavPropWithoutValues({
    this.davgetlastmodified,
    this.davgetetag,
    this.davgetcontenttype,
    this.davgetcontentlength,
    this.davresourcetype,
    this.ocid,
    this.ocfileid,
    this.ocfavorite,
    this.occommentshref,
    this.occommentscount,
    this.occommentsunread,
    this.ocdownloadurl,
    this.ocownerid,
    this.ocownerdisplayname,
    this.ocsize,
    this.ocpermissions,
    this.ncnote,
    this.ncdatafingerprint,
    this.nchaspreview,
    this.ncmounttype,
    this.ncisencrypted,
    this.ncmetadataetag,
    this.ncuploadtime,
    this.nccreationtime,
    this.ncrichworkspace,
    this.ocssharepermissions,
    this.ocmsharepermissions,
  });

  const WebDavPropWithoutValues.fromBools({
    bool davgetlastmodified = false,
    bool davgetetag = false,
    bool davgetcontenttype = false,
    bool davgetcontentlength = false,
    bool davresourcetype = false,
    bool ocid = false,
    bool ocfileid = false,
    bool ocfavorite = false,
    bool occommentshref = false,
    bool occommentscount = false,
    bool occommentsunread = false,
    bool ocdownloadurl = false,
    bool ocownerid = false,
    bool ocownerdisplayname = false,
    bool ocsize = false,
    bool ocpermissions = false,
    bool ncnote = false,
    bool ncdatafingerprint = false,
    bool nchaspreview = false,
    bool ncmounttype = false,
    bool ncisencrypted = false,
    bool ncmetadataetag = false,
    bool ncuploadtime = false,
    bool nccreationtime = false,
    bool ncrichworkspace = false,
    bool ocssharepermissions = false,
    bool ocmsharepermissions = false,
  })  : davgetlastmodified = davgetlastmodified ? const [null] : null,
        davgetetag = davgetetag ? const [null] : null,
        davgetcontenttype = davgetcontenttype ? const [null] : null,
        davgetcontentlength = davgetcontentlength ? const [null] : null,
        davresourcetype = davresourcetype ? const [null] : null,
        ocid = ocid ? const [null] : null,
        ocfileid = ocfileid ? const [null] : null,
        ocfavorite = ocfavorite ? const [null] : null,
        occommentshref = occommentshref ? const [null] : null,
        occommentscount = occommentscount ? const [null] : null,
        occommentsunread = occommentsunread ? const [null] : null,
        ocdownloadurl = ocdownloadurl ? const [null] : null,
        ocownerid = ocownerid ? const [null] : null,
        ocownerdisplayname = ocownerdisplayname ? const [null] : null,
        ocsize = ocsize ? const [null] : null,
        ocpermissions = ocpermissions ? const [null] : null,
        ncnote = ncnote ? const [null] : null,
        ncdatafingerprint = ncdatafingerprint ? const [null] : null,
        nchaspreview = nchaspreview ? const [null] : null,
        ncmounttype = ncmounttype ? const [null] : null,
        ncisencrypted = ncisencrypted ? const [null] : null,
        ncmetadataetag = ncmetadataetag ? const [null] : null,
        ncuploadtime = ncuploadtime ? const [null] : null,
        nccreationtime = nccreationtime ? const [null] : null,
        ncrichworkspace = ncrichworkspace ? const [null] : null,
        ocssharepermissions = ocssharepermissions ? const [null] : null,
        ocmsharepermissions = ocmsharepermissions ? const [null] : null;

  factory WebDavPropWithoutValues.fromXmlElement(XmlElement element) =>
      _$WebDavPropWithoutValuesFromXmlElement(element);

  @annotation.XmlElement(
    name: 'getlastmodified',
    namespace: namespaceDav,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? davgetlastmodified;

  @annotation.XmlElement(
    name: 'getetag',
    namespace: namespaceDav,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? davgetetag;

  @annotation.XmlElement(
    name: 'getcontenttype',
    namespace: namespaceDav,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? davgetcontenttype;

  @annotation.XmlElement(
    name: 'getcontentlength',
    namespace: namespaceDav,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? davgetcontentlength;

  @annotation.XmlElement(
    name: 'resourcetype',
    namespace: namespaceDav,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? davresourcetype;

  @annotation.XmlElement(
    name: 'id',
    namespace: namespaceOwncloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? ocid;

  @annotation.XmlElement(
    name: 'fileid',
    namespace: namespaceOwncloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? ocfileid;

  @annotation.XmlElement(
    name: 'favorite',
    namespace: namespaceOwncloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? ocfavorite;

  @annotation.XmlElement(
    name: 'comments-href',
    namespace: namespaceOwncloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? occommentshref;

  @annotation.XmlElement(
    name: 'comments-count',
    namespace: namespaceOwncloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? occommentscount;

  @annotation.XmlElement(
    name: 'comments-unread',
    namespace: namespaceOwncloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? occommentsunread;

  @annotation.XmlElement(
    name: 'downloadURL',
    namespace: namespaceOwncloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? ocdownloadurl;

  @annotation.XmlElement(
    name: 'owner-id',
    namespace: namespaceOwncloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? ocownerid;

  @annotation.XmlElement(
    name: 'owner-display-name',
    namespace: namespaceOwncloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? ocownerdisplayname;

  @annotation.XmlElement(
    name: 'size',
    namespace: namespaceOwncloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? ocsize;

  @annotation.XmlElement(
    name: 'permissions',
    namespace: namespaceOwncloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? ocpermissions;

  @annotation.XmlElement(
    name: 'note',
    namespace: namespaceNextcloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? ncnote;

  @annotation.XmlElement(
    name: 'data-fingerprint',
    namespace: namespaceNextcloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? ncdatafingerprint;

  @annotation.XmlElement(
    name: 'has-preview',
    namespace: namespaceNextcloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? nchaspreview;

  @annotation.XmlElement(
    name: 'mount-type',
    namespace: namespaceNextcloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? ncmounttype;

  @annotation.XmlElement(
    name: 'is-encrypted',
    namespace: namespaceNextcloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? ncisencrypted;

  @annotation.XmlElement(
    name: 'metadata_etag',
    namespace: namespaceNextcloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? ncmetadataetag;

  @annotation.XmlElement(
    name: 'upload_time',
    namespace: namespaceNextcloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? ncuploadtime;

  @annotation.XmlElement(
    name: 'creation_time',
    namespace: namespaceNextcloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? nccreationtime;

  @annotation.XmlElement(
    name: 'rich-workspace',
    namespace: namespaceNextcloud,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? ncrichworkspace;

  @annotation.XmlElement(
    name: 'share-permissions',
    namespace: namespaceOpenCollaborationServices,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? ocssharepermissions;

  @annotation.XmlElement(
    name: 'share-permissions',
    namespace: namespaceOpenCloudMesh,
    includeIfNull: true,
    isSelfClosing: true,
  )
  final List<String?>? ocmsharepermissions;
}

@immutable
@annotation.XmlSerializable(createMixin: true)
@annotation.XmlRootElement(name: 'prop', namespace: namespaceDav)
class WebDavProp with _$WebDavPropXmlSerializableMixin {
  const WebDavProp({
    this.davgetlastmodified,
    this.davgetetag,
    this.davgetcontenttype,
    this.davgetcontentlength,
    this.davresourcetype,
    this.ocid,
    this.ocfileid,
    this.ocfavorite,
    this.occommentshref,
    this.occommentscount,
    this.occommentsunread,
    this.ocdownloadurl,
    this.ocownerid,
    this.ocownerdisplayname,
    this.ocsize,
    this.ocpermissions,
    this.ncnote,
    this.ncdatafingerprint,
    this.nchaspreview,
    this.ncmounttype,
    this.ncisencrypted,
    this.ncmetadataetag,
    this.ncuploadtime,
    this.nccreationtime,
    this.ncrichworkspace,
    this.ocssharepermissions,
    this.ocmsharepermissions,
  });

  factory WebDavProp.fromXmlElement(XmlElement element) => _$WebDavPropFromXmlElement(element);

  @annotation.XmlElement(
    name: 'getlastmodified',
    namespace: namespaceDav,
    includeIfNull: false,
  )
  final String? davgetlastmodified;

  @annotation.XmlElement(
    name: 'getetag',
    namespace: namespaceDav,
    includeIfNull: false,
  )
  final String? davgetetag;

  @annotation.XmlElement(
    name: 'getcontenttype',
    namespace: namespaceDav,
    includeIfNull: false,
  )
  final String? davgetcontenttype;

  @annotation.XmlElement(
    name: 'getcontentlength',
    namespace: namespaceDav,
    includeIfNull: false,
  )
  final int? davgetcontentlength;

  @annotation.XmlElement(
    name: 'resourcetype',
    namespace: namespaceDav,
    includeIfNull: false,
  )
  final WebDavResourcetype? davresourcetype;

  @annotation.XmlElement(
    name: 'id',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final String? ocid;

  @annotation.XmlElement(
    name: 'fileid',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final String? ocfileid;

  @annotation.XmlElement(
    name: 'favorite',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final int? ocfavorite;

  @annotation.XmlElement(
    name: 'comments-href',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final String? occommentshref;

  @annotation.XmlElement(
    name: 'comments-count',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final int? occommentscount;

  @annotation.XmlElement(
    name: 'comments-unread',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final int? occommentsunread;

  @annotation.XmlElement(
    name: 'downloadURL',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final String? ocdownloadurl;

  @annotation.XmlElement(
    name: 'owner-id',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final String? ocownerid;

  @annotation.XmlElement(
    name: 'owner-display-name',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final String? ocownerdisplayname;

  @annotation.XmlElement(
    name: 'size',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final int? ocsize;

  @annotation.XmlElement(
    name: 'permissions',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final String? ocpermissions;

  @annotation.XmlElement(
    name: 'note',
    namespace: namespaceNextcloud,
    includeIfNull: false,
  )
  final String? ncnote;

  @annotation.XmlElement(
    name: 'data-fingerprint',
    namespace: namespaceNextcloud,
    includeIfNull: false,
  )
  final String? ncdatafingerprint;

  @annotation.XmlElement(
    name: 'has-preview',
    namespace: namespaceNextcloud,
    includeIfNull: false,
  )
  final bool? nchaspreview;

  @annotation.XmlElement(
    name: 'mount-type',
    namespace: namespaceNextcloud,
    includeIfNull: false,
  )
  final String? ncmounttype;

  @annotation.XmlElement(
    name: 'is-encrypted',
    namespace: namespaceNextcloud,
    includeIfNull: false,
  )
  final int? ncisencrypted;

  @annotation.XmlElement(
    name: 'metadata_etag',
    namespace: namespaceNextcloud,
    includeIfNull: false,
  )
  final String? ncmetadataetag;

  @annotation.XmlElement(
    name: 'upload_time',
    namespace: namespaceNextcloud,
    includeIfNull: false,
  )
  final int? ncuploadtime;

  @annotation.XmlElement(
    name: 'creation_time',
    namespace: namespaceNextcloud,
    includeIfNull: false,
  )
  final int? nccreationtime;

  @annotation.XmlElement(
    name: 'rich-workspace',
    namespace: namespaceNextcloud,
    includeIfNull: false,
  )
  final String? ncrichworkspace;

  @annotation.XmlElement(
    name: 'share-permissions',
    namespace: namespaceOpenCollaborationServices,
    includeIfNull: false,
  )
  final int? ocssharepermissions;

  @annotation.XmlElement(
    name: 'share-permissions',
    namespace: namespaceOpenCloudMesh,
    includeIfNull: false,
  )
  final String? ocmsharepermissions;
}

@immutable
@annotation.XmlSerializable(createMixin: true)
@annotation.XmlRootElement(name: 'filter-rules', namespace: namespaceOwncloud)
class WebDavOcFilterRules with _$WebDavOcFilterRulesXmlSerializableMixin {
  const WebDavOcFilterRules({
    this.davgetlastmodified,
    this.davgetetag,
    this.davgetcontenttype,
    this.davgetcontentlength,
    this.davresourcetype,
    this.ocid,
    this.ocfileid,
    this.ocfavorite,
    this.occommentshref,
    this.occommentscount,
    this.occommentsunread,
    this.ocdownloadurl,
    this.ocownerid,
    this.ocownerdisplayname,
    this.ocsize,
    this.ocpermissions,
    this.ncnote,
    this.ncdatafingerprint,
    this.nchaspreview,
    this.ncmounttype,
    this.ncisencrypted,
    this.ncmetadataetag,
    this.ncuploadtime,
    this.nccreationtime,
    this.ncrichworkspace,
    this.ocssharepermissions,
    this.ocmsharepermissions,
  });

  factory WebDavOcFilterRules.fromXmlElement(XmlElement element) => _$WebDavOcFilterRulesFromXmlElement(element);

  @annotation.XmlElement(
    name: 'getlastmodified',
    namespace: namespaceDav,
    includeIfNull: false,
  )
  final String? davgetlastmodified;

  @annotation.XmlElement(
    name: 'getetag',
    namespace: namespaceDav,
    includeIfNull: false,
  )
  final String? davgetetag;

  @annotation.XmlElement(
    name: 'getcontenttype',
    namespace: namespaceDav,
    includeIfNull: false,
  )
  final String? davgetcontenttype;

  @annotation.XmlElement(
    name: 'getcontentlength',
    namespace: namespaceDav,
    includeIfNull: false,
  )
  final int? davgetcontentlength;

  @annotation.XmlElement(
    name: 'resourcetype',
    namespace: namespaceDav,
    includeIfNull: false,
  )
  final WebDavResourcetype? davresourcetype;

  @annotation.XmlElement(
    name: 'id',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final String? ocid;

  @annotation.XmlElement(
    name: 'fileid',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final String? ocfileid;

  @annotation.XmlElement(
    name: 'favorite',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final int? ocfavorite;

  @annotation.XmlElement(
    name: 'comments-href',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final String? occommentshref;

  @annotation.XmlElement(
    name: 'comments-count',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final int? occommentscount;

  @annotation.XmlElement(
    name: 'comments-unread',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final int? occommentsunread;

  @annotation.XmlElement(
    name: 'downloadURL',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final String? ocdownloadurl;

  @annotation.XmlElement(
    name: 'owner-id',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final String? ocownerid;

  @annotation.XmlElement(
    name: 'owner-display-name',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final String? ocownerdisplayname;

  @annotation.XmlElement(
    name: 'size',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final int? ocsize;

  @annotation.XmlElement(
    name: 'permissions',
    namespace: namespaceOwncloud,
    includeIfNull: false,
  )
  final String? ocpermissions;

  @annotation.XmlElement(
    name: 'note',
    namespace: namespaceNextcloud,
    includeIfNull: false,
  )
  final String? ncnote;

  @annotation.XmlElement(
    name: 'data-fingerprint',
    namespace: namespaceNextcloud,
    includeIfNull: false,
  )
  final String? ncdatafingerprint;

  @annotation.XmlElement(
    name: 'has-preview',
    namespace: namespaceNextcloud,
    includeIfNull: false,
  )
  final bool? nchaspreview;

  @annotation.XmlElement(
    name: 'mount-type',
    namespace: namespaceNextcloud,
    includeIfNull: false,
  )
  final String? ncmounttype;

  @annotation.XmlElement(
    name: 'is-encrypted',
    namespace: namespaceNextcloud,
    includeIfNull: false,
  )
  final int? ncisencrypted;

  @annotation.XmlElement(
    name: 'metadata_etag',
    namespace: namespaceNextcloud,
    includeIfNull: false,
  )
  final String? ncmetadataetag;

  @annotation.XmlElement(
    name: 'upload_time',
    namespace: namespaceNextcloud,
    includeIfNull: false,
  )
  final int? ncuploadtime;

  @annotation.XmlElement(
    name: 'creation_time',
    namespace: namespaceNextcloud,
    includeIfNull: false,
  )
  final int? nccreationtime;

  @annotation.XmlElement(
    name: 'rich-workspace',
    namespace: namespaceNextcloud,
    includeIfNull: false,
  )
  final String? ncrichworkspace;

  @annotation.XmlElement(
    name: 'share-permissions',
    namespace: namespaceOpenCollaborationServices,
    includeIfNull: false,
  )
  final int? ocssharepermissions;

  @annotation.XmlElement(
    name: 'share-permissions',
    namespace: namespaceOpenCloudMesh,
    includeIfNull: false,
  )
  final String? ocmsharepermissions;
}
