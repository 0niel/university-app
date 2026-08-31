// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mini_app.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MiniApp _$MiniAppFromJson(Map<String, dynamic> json) => _MiniApp(
  id: json['id'] as String,
  slug: json['slug'] as String,
  name: json['name'] as String,
  description: json['description'] as String? ?? '',
  iconEmoji: json['iconEmoji'] as String? ?? '🧩',
  iconUrl: json['iconUrl'] as String?,
  accentColor: json['accentColor'] as String? ?? '#7C5CFF',
  category: json['category'] == null
      ? MiniAppCategory.other
      : _categoryFromJson(json['category']),
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  sourceKind: json['sourceKind'] == null
      ? MiniAppSourceKind.hosted
      : _sourceKindFromJson(json['sourceKind']),
  originUrl: json['originUrl'] as String?,
  entryPath: json['entryPath'] as String? ?? '/',
  status: json['status'] == null
      ? MiniAppStatus.draft
      : _statusFromJson(json['status']),
  reviewNotes: json['reviewNotes'] as String?,
  version: (json['version'] as num?)?.toInt() ?? 1,
  launchCount: (json['launchCount'] as num?)?.toInt() ?? 0,
  ratingAvg: json['ratingAvg'] == null ? 0 : _ratingFromJson(json['ratingAvg']),
  ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
  ownerId: json['ownerId'] as String?,
  isOwner: json['isOwner'] as bool? ?? false,
  isFeatured: json['isFeatured'] as bool? ?? false,
  myRating: (json['myRating'] as num?)?.toInt(),
  isHidden: json['isHidden'] as bool? ?? false,
  hasMyOpenReport: json['hasMyOpenReport'] as bool? ?? false,
  openReportCount: (json['openReportCount'] as num?)?.toInt(),
  requestedPermissions: json['requestedPermissions'] == null
      ? const <MiniAppPermission>[]
      : MiniAppPermission.listFromJson(json['requestedPermissions']),
  grantedPermissions: _nullablePermissionsFromJson(json['grantedPermissions']),
  createdAt: _localDateFromJson(json['createdAt']),
  publishedAt: _localDateFromJson(json['publishedAt']),
);

Map<String, dynamic> _$MiniAppToJson(_MiniApp instance) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'name': instance.name,
  'description': instance.description,
  'iconEmoji': instance.iconEmoji,
  'iconUrl': instance.iconUrl,
  'accentColor': instance.accentColor,
  'category': _categoryToJson(instance.category),
  'tags': instance.tags,
  'sourceKind': _sourceKindToJson(instance.sourceKind),
  'originUrl': instance.originUrl,
  'entryPath': instance.entryPath,
  'status': _statusToJson(instance.status),
  'reviewNotes': instance.reviewNotes,
  'version': instance.version,
  'launchCount': instance.launchCount,
  'ratingAvg': _ratingToJson(instance.ratingAvg),
  'ratingCount': instance.ratingCount,
  'ownerId': instance.ownerId,
  'isOwner': instance.isOwner,
  'isFeatured': instance.isFeatured,
  'myRating': instance.myRating,
  'isHidden': instance.isHidden,
  'hasMyOpenReport': instance.hasMyOpenReport,
  'openReportCount': instance.openReportCount,
  'requestedPermissions': _permissionsToJson(instance.requestedPermissions),
  'grantedPermissions': _nullablePermissionsToJson(instance.grantedPermissions),
  'createdAt': _dateToJson(instance.createdAt),
  'publishedAt': _dateToJson(instance.publishedAt),
};
