import 'dart:async';
import 'dart:developer';
import 'dart:math' show Random;
import 'dart:typed_data';

import 'package:campus_repository/src/collab_note_presence_session.dart';
import 'package:campus_repository/src/collab_note_realtime_session.dart';
import 'package:campus_repository/src/group_space_presence_session.dart';
import 'package:campus_repository/src/group_space_realtime_session.dart';
import 'package:campus_repository/src/json_rows.dart';
import 'package:campus_repository/src/models/campus_models.dart';
import 'package:campus_repository/src/supabase_collab_note_presence_session.dart';
import 'package:campus_repository/src/supabase_collab_note_realtime_session.dart';
import 'package:campus_repository/src/supabase_group_space_presence_session.dart';
import 'package:campus_repository/src/supabase_group_space_realtime_session.dart';
import 'package:supabase/supabase.dart';

class CampusRepository {
  factory CampusRepository({
    required SupabaseClient supabase,
    required String organizationId,
  }) => CampusRepository._(supabase, organizationId);

  const CampusRepository._(this._supabase, this._organizationId);

  final SupabaseClient _supabase;
  final String _organizationId;

  Future<GroupSpace> getGroupSpace() async {
    final res = await _supabase.rpc<Object?>(
      'get_group_space',
      params: {'p_organization_id': _organizationId},
    );
    if (res is Map) return GroupSpace.fromJson(res.cast());
    throw const FormatException('get_group_space returned an invalid result');
  }

  Future<String> addGroupLink({
    required String title,
    required String url,
    String emoji = '🔗',
    String kind = 'link',
  }) async {
    final address = GroupLinkAddress.parse(
      url,
      telegramOnly: kind == 'telegram',
    );
    final response = await _supabase.rpc<Object?>(
      'add_group_link',
      params: {
        'p_organization_id': _organizationId,
        'p_title': title,
        'p_url': address.toString(),
        'p_emoji': emoji,
        'p_kind': kind,
      },
    );
    return _parseUuid(response, 'add_group_link');
  }

  Future<void> deleteGroupLink(String id) async {
    await _supabase.rpc<Object?>('delete_group_link', params: {'p_id': id});
  }

  Future<String> createGroupPost({
    required String title,
    String body = '',
    String kind = 'note',
    bool pinned = false,
  }) async {
    final response = await _supabase.rpc<Object?>(
      'create_group_post',
      params: {
        'p_organization_id': _organizationId,
        'p_title': title,
        'p_body': body,
        'p_kind': kind,
        'p_pinned': pinned,
      },
    );
    return _parseUuid(response, 'create_group_post');
  }

  Future<void> deleteGroupPost(String id) async {
    await _supabase.rpc<Object?>('delete_group_post', params: {'p_id': id});
  }

  Future<List<GroupPostSearchResult>> searchGroupPosts(String query) async {
    if (query.trim().isEmpty) return const [];
    final res = await _supabase.rpc<Object?>(
      'search_group_posts',
      params: {'p_query': query},
    );
    return decodeJsonRows(
      res,
      context: 'search_group_posts',
    ).map(GroupPostSearchResult.fromJson).toList();
  }

  Future<void> logSearchQuery(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) return;
    await _supabase.rpc<Object?>(
      'log_search_query',
      params: {'p_query': trimmed},
    );
  }

  Future<List<TrendingSearch>> getTrendingSearches() async {
    final res = await _supabase.rpc<Object?>('trending_searches');
    return decodeJsonRows(
      res,
      context: 'trending_searches',
    ).map(TrendingSearch.fromJson).toList();
  }

  Future<List<Poll>> getPolls({
    PollFilter filter = PollFilter.all,
    PollCategory? category,
    String? query,
    int limit = 20,
    int offset = 0,
  }) async {
    final res = await _supabase.rpc<Object?>(
      'get_polls_v2',
      params: {
        'p_organization_id': _organizationId,
        'p_filter': filter.wire,
        'p_category': category?.wire,
        'p_query': query,
        'p_limit': limit,
        'p_offset': offset,
      },
    );
    return decodeJsonRows(
      res,
      context: 'get_polls_v2',
    ).map(Poll.fromJson).toList();
  }

  Future<Poll> createPoll({
    required String title,
    required List<PollQuestionDraft> questions,
    String description = '',
    PollCategory? category,
    bool isAnonymous = false,
    PollResultsVisibility resultsVisibility = PollResultsVisibility.always,
    DateTime? expiresAt,
    bool allowChange = false,
  }) async {
    final res = await _supabase.rpc<Object?>(
      'create_poll_v2',
      params: {
        'p_organization_id': _organizationId,
        'p_title': title,
        'p_description': description,
        'p_category': category?.wire,
        'p_is_anonymous': isAnonymous,
        'p_results_visibility': resultsVisibility.wire,
        'p_expires_at': expiresAt?.toUtc().toIso8601String(),
        'p_allow_change': allowChange,
        'p_questions': questions.map((question) => question.toJson()).toList(),
      },
    );
    if (res is Map) return Poll.fromJson(res.cast());
    throw const FormatException('create_poll_v2 returned an invalid result');
  }

  Future<Poll> submitPollAnswers({
    required String pollId,
    required List<PollAnswer> answers,
  }) async {
    final res = await _supabase.rpc<Object?>(
      'submit_poll_answers',
      params: {
        'p_poll_id': pollId,
        'p_answers': answers.map((answer) => answer.toJson()).toList(),
      },
    );
    if (res is Map) return Poll.fromJson(res.cast());
    throw const FormatException(
      'submit_poll_answers returned an invalid result',
    );
  }

  Future<Poll> closePoll(String pollId) async {
    final res = await _supabase.rpc<Object?>(
      'close_poll',
      params: {'p_poll_id': pollId},
    );
    if (res is Map) return Poll.fromJson(res.cast());
    throw const FormatException('close_poll returned an invalid result');
  }

  Future<void> deletePoll(String pollId) async {
    await _supabase.rpc<Object?>('delete_poll', params: {'p_poll_id': pollId});
  }

  Future<bool> toggleGroupPostLike(String id) async {
    final response = await _supabase.rpc<Object?>(
      'toggle_group_post_like',
      params: {'p_id': id},
    );
    if (response case final bool liked) return liked;
    throw const FormatException(
      'toggle_group_post_like returned an invalid result',
    );
  }

  Future<void> setMyBirthDate(DateTime date) async {
    await _supabase.rpc<Object?>(
      'set_my_birth_date',
      params: {'p_date': date.toIso8601String().substring(0, 10)},
    );
  }

  Future<List<GroupPostComment>> getGroupPostComments(String postId) async {
    final res = await _supabase.rpc<Object?>(
      'get_group_post_comments',
      params: {'p_post_id': postId},
    );
    return _mapRows(res, GroupPostComment.fromJson);
  }

  Future<GroupPostComment> addGroupPostComment({
    required String postId,
    required String body,
  }) async {
    final res = await _supabase.rpc<Object?>(
      'add_group_post_comment',
      params: {'p_post_id': postId, 'p_body': body},
    );
    if (res is Map) return GroupPostComment.fromJson(res.cast());
    throw const FormatException(
      'add_group_post_comment returned an invalid result',
    );
  }

  Future<void> deleteGroupPostComment(String id) async {
    await _supabase.rpc<Object?>(
      'delete_group_post_comment',
      params: {'p_id': id},
    );
  }

  GroupSpaceRealtimeSession openGroupSpaceRealtime(String groupId) {
    return SupabaseGroupSpaceRealtimeSession(
      channel: _supabase.channel('group-space:$groupId'),
      groupId: groupId,
    );
  }

  GroupSpacePresenceSession openGroupSpacePresence(String groupId) {
    return SupabaseGroupSpacePresenceSession(
      channel: _supabase.channel(
        'group-presence:$groupId',
        opts: const RealtimeChannelConfig(private: true),
      ),
    );
  }

  Future<List<CampusEvent>> getEvents({
    bool includePast = false,
    DateTime? from,
    DateTime? to,
  }) async {
    final res = await _supabase.rpc<Object?>(
      'get_events',
      params: {
        'p_organization_id': _organizationId,
        'p_include_past': includePast,
        'p_from': from?.toUtc().toIso8601String(),
        'p_to': to?.toUtc().toIso8601String(),
      },
    );
    return _mapRows(res, CampusEvent.fromJson);
  }

  Future<void> createEvent({
    required String title,
    required DateTime startsAt,
    String place = '',
    String emoji = '🎉',
    String category = 'other',
    String description = '',
    DateTime? endsAt,
  }) async {
    await _supabase.rpc<Object?>(
      'create_event',
      params: {
        'p_organization_id': _organizationId,
        'p_title': title,
        'p_starts_at': startsAt.toUtc().toIso8601String(),
        'p_place': place,
        'p_emoji': emoji,
        'p_category': category,
        'p_description': description,
        'p_ends_at': endsAt?.toUtc().toIso8601String(),
      },
    );
  }

  Future<void> updateEvent({
    required String id,
    String? title,
    DateTime? startsAt,
    DateTime? endsAt,
    String? place,
    String? emoji,
    String? category,
    String? description,
  }) async {
    await _supabase.rpc<Object?>(
      'update_event',
      params: {
        'p_id': id,
        'p_title': title,
        'p_starts_at': startsAt?.toUtc().toIso8601String(),
        'p_ends_at': endsAt?.toUtc().toIso8601String(),
        'p_place': place,
        'p_emoji': emoji,
        'p_category': category,
        'p_description': description,
      },
    );
  }

  Future<void> setEventRsvp({
    required String eventId,
    required bool going,
  }) async {
    await _supabase.rpc<Object?>(
      'set_event_rsvp',
      params: {'p_event_id': eventId, 'p_going': going},
    );
  }

  Future<void> deleteEvent(String id) async {
    await _supabase.rpc<Object?>('delete_event', params: {'p_id': id});
  }

  static const String _marketMediaBucket = 'marketplace-media';

  Future<List<MarketListing>> getListings() async {
    final res = await _supabase.rpc<Object?>(
      'get_listings',
      params: {'p_organization_id': _organizationId},
    );
    return _resolveMarketMedia(_mapRows(res, MarketListing.fromJson));
  }

  List<MarketListing> _resolveMarketMedia(List<MarketListing> items) {
    if (items.every((item) => item.media.isEmpty)) return items;
    final storage = _supabase.storage.from(_marketMediaBucket);
    return [
      for (final item in items)
        item.media.isEmpty
            ? item
            : item.copyWith(
                media: [
                  for (final media in item.media)
                    media.copyWith(url: storage.getPublicUrl(media.path)),
                ],
              ),
    ];
  }

  Future<String> uploadListingMedia({
    required Uint8List bytes,
    required String contentType,
    required String extension,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      throw const AuthException('Sign in before uploading media');
    }
    final path = '$userId/${_randomMaterialObjectKey()}.$extension';
    await _supabase.storage
        .from(_marketMediaBucket)
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: contentType),
        );
    return path;
  }

  Future<String> createListing({
    required String title,
    required int price,
    required String telegramContact,
    String category = 'other',
    String description = '',
    bool isFree = false,
    List<MarketMediaItem> media = const [],
    bool showContact = false,
  }) async {
    final response = await _supabase.rpc<Object?>(
      'create_listing_v2',
      params: {
        'p_organization_id': _organizationId,
        'p_title': title,
        'p_price': price,
        'p_category': category,
        'p_description': description,
        'p_is_free': isFree,
        'p_media': _mediaPayload(media),
        'p_telegram_contact': telegramContact,
        'p_show_contact': showContact,
      },
    );
    return _parseUuid(response, 'create_listing_v2');
  }

  Future<void> updateListing({
    required String id,
    required String title,
    required int price,
    required String category,
    required String description,
    required bool isFree,
    required List<MarketMediaItem> media,
    required String telegramContact,
    required bool showContact,
  }) async {
    final response = await _supabase.rpc<Object?>(
      'update_listing',
      params: {
        'p_id': id,
        'p_title': title,
        'p_price': price,
        'p_category': category,
        'p_description': description,
        'p_is_free': isFree,
        'p_media': _mediaPayload(media),
        'p_telegram_contact': telegramContact,
        'p_show_contact': showContact,
      },
    );
    await _removeMarketMedia(_stringList(response));
  }

  Future<void> setListingSold({required String id, required bool sold}) async {
    await _supabase.rpc<Object?>(
      'set_listing_sold',
      params: {'p_id': id, 'p_sold': sold},
    );
  }

  Future<void> archiveListing(String id) async {
    final response = await _supabase.rpc<Object?>(
      'archive_listing',
      params: {'p_id': id},
    );
    await _removeMarketMedia(_stringList(response));
  }

  Future<void> deleteListing(String id) async {
    final response = await _supabase.rpc<Object?>(
      'delete_listing',
      params: {'p_id': id},
    );
    await _removeMarketMedia(_stringList(response));
  }

  List<Map<String, Object?>> _mediaPayload(List<MarketMediaItem> media) => [
    for (final item in media)
      {
        'path': item.path,
        'kind': item.kind.name,
        'width': item.width,
        'height': item.height,
        'duration': item.duration,
      },
  ];

  Future<void> _removeMarketMedia(List<String> paths) async {
    if (paths.isEmpty) return;
    try {
      await _supabase.storage.from(_marketMediaBucket).remove(paths);
    } on Object catch (error, stackTrace) {
      log(
        'Failed to remove orphaned marketplace media',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  List<String> _stringList(Object? value) => value is List
      ? value.whereType<String>().toList(growable: false)
      : const [];

  Future<List<Mentor>> getMentors() async {
    final res = await _supabase.rpc<Object?>(
      'get_mentors',
      params: {'p_organization_id': _organizationId},
    );
    return _mapRows(res, Mentor.fromJson);
  }

  Future<void> upsertMentorProfile({
    required List<String> topics,
    required String telegramHandle,
    String bio = '',
    String level = '',
    List<String> formats = const [],
    int price = 0,
  }) async {
    await _supabase.rpc<Object?>(
      'upsert_mentor_profile',
      params: {
        'p_organization_id': _organizationId,
        'p_topics': topics,
        'p_telegram_handle': telegramHandle,
        'p_bio': bio,
        'p_level': level,
        'p_formats': formats,
        'p_price': price,
      },
    );
  }

  Future<void> deleteMentorProfile() async {
    await _supabase.rpc<Object?>(
      'delete_mentor_profile',
      params: {'p_organization_id': _organizationId},
    );
  }

  Future<void> createMentorRequest({
    required String mentorUserId,
    String topic = '',
    String whenSlot = 'week',
    String message = '',
  }) async {
    await _supabase.rpc<Object?>(
      'create_mentor_request',
      params: {
        'p_organization_id': _organizationId,
        'p_mentor_user_id': mentorUserId,
        'p_topic': topic,
        'p_when_slot': whenSlot,
        'p_message': message,
      },
    );
  }

  Future<List<MentorRequest>> getMyMentorRequests() async {
    final res = await _supabase.rpc<Object?>(
      'get_my_mentor_requests',
      params: {'p_organization_id': _organizationId},
    );
    return _mapRows(res, MentorRequest.fromJson);
  }

  Future<void> actOnMentorRequest({
    required String id,
    required MentorRequestAction action,
  }) async {
    await _supabase.rpc<Object?>(
      'act_on_mentor_request',
      params: {'p_id': id, 'p_action': action.wireValue},
    );
  }

  Future<List<Team>> getTeams() async {
    final res = await _supabase.rpc<Object?>(
      'get_teams',
      params: {'p_organization_id': _organizationId},
    );
    return _mapRows(res, Team.fromJson);
  }

  Future<void> createTeam({
    required String title,
    String eventName = '',
    String description = '',
    List<String> neededRoles = const [],
    int capacity = 5,
    String kind = 'hackathon',
    DateTime? deadlineAt,
    bool boost = false,
  }) async {
    await _supabase.rpc<Object?>(
      'create_team',
      params: {
        'p_organization_id': _organizationId,
        'p_title': title,
        'p_event_name': eventName,
        'p_description': description,
        'p_needed_roles': neededRoles,
        'p_capacity': capacity,
        'p_kind': kind,
        'p_deadline_at': deadlineAt?.toUtc().toIso8601String(),
        'p_boost': boost,
      },
    );
  }

  Future<void> applyToTeam({
    required String teamId,
    String role = '',
    String message = '',
    bool attachProfile = true,
  }) async {
    await _supabase.rpc<Object?>(
      'apply_to_team',
      params: {
        'p_team_id': teamId,
        'p_role': role,
        'p_message': message,
        'p_attach_profile': attachProfile,
      },
    );
  }

  Future<void> updateTeam({
    required String id,
    required String title,
    String eventName = '',
    String description = '',
    List<String> neededRoles = const [],
    int capacity = 5,
    String kind = 'hackathon',
    DateTime? deadlineAt,
    String? status,
  }) async {
    await _supabase.rpc<Object?>(
      'update_team',
      params: {
        'p_id': id,
        'p_title': title,
        'p_event_name': eventName,
        'p_description': description,
        'p_needed_roles': neededRoles,
        'p_capacity': capacity,
        'p_kind': kind,
        'p_deadline_at': deadlineAt?.toUtc().toIso8601String(),
        'p_status': status,
      },
    );
  }

  Future<List<TeamApplication>> getTeamApplications(String teamId) async {
    final res = await _supabase.rpc<Object?>(
      'get_team_applications',
      params: {'p_team_id': teamId},
    );
    return _mapRows(res, TeamApplication.fromJson);
  }

  Future<void> actOnTeamApplication({
    required String id,
    required TeamApplicationAction action,
  }) async {
    await _supabase.rpc<Object?>(
      'act_on_team_application',
      params: {'p_id': id, 'p_action': action.wireValue},
    );
  }

  Future<void> leaveTeam(String teamId) async {
    await _supabase.rpc<Object?>(
      'leave_team',
      params: {'p_team_id': teamId},
    );
  }

  Future<void> deleteTeam(String id) async {
    await _supabase.rpc<Object?>('delete_team', params: {'p_id': id});
  }

  Future<List<FreeRoom>> getFreeRooms() async {
    final res = await _supabase.rpc<Object?>(
      'get_free_rooms',
      params: {'p_organization_id': _organizationId},
    );
    return _mapRows(res, FreeRoom.fromJson);
  }

  static const String _roomPhotosBucket = 'room-photos';
  static const int roomPhotoMaxBytes = 8 * 1024 * 1024;
  static const int roomPhotoMaxPerUpload = 5;

  Future<List<RoomPhoto>> getRoomPhotos({
    required String campus,
    required String roomKey,
  }) async {
    final res = await _supabase.rpc<Object?>(
      'get_room_photos',
      params: {
        'p_organization_id': _organizationId,
        'p_campus': campus,
        'p_room_key': roomKey,
      },
    );
    return _withRoomPhotoUrls(_mapRows(res, RoomPhoto.fromJson));
  }

  Future<RoomPhoto> addRoomPhoto({
    required String campus,
    required String roomKey,
    required Uint8List bytes,
    required String contentType,
    int? width,
    int? height,
  }) async {
    if (bytes.isEmpty || bytes.length > roomPhotoMaxBytes) {
      throw ArgumentError('Room photo size is invalid');
    }
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      throw const AuthException('Sign in before uploading a room photo');
    }
    final path =
        '$userId/${_randomMaterialObjectKey()}.'
        '${_roomPhotoExtension(contentType)}';
    await _supabase.storage
        .from(_roomPhotosBucket)
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: contentType),
        );
    try {
      final response = await _supabase.rpc<Object?>(
        'add_room_photo',
        params: {
          'p_organization_id': _organizationId,
          'p_campus': campus,
          'p_room_key': roomKey,
          'p_path': path,
          'p_width': width,
          'p_height': height,
        },
      );
      if (response is! Map) {
        throw const FormatException(
          'add_room_photo returned an invalid result',
        );
      }
      final [photo] = _withRoomPhotoUrls([
        RoomPhoto.fromJson(response.cast()),
      ]);
      return photo;
    } on Object catch (error, stackTrace) {
      await _removeRoomPhotoFile(path);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> deleteRoomPhoto(String id) async {
    final path = await _supabase.rpc<Object?>(
      'delete_room_photo_v2',
      params: {'p_id': id},
    );
    if (path is! String || path.isEmpty) {
      throw const FormatException('Invalid room photo deletion response');
    }
    await _removeRoomPhotoFile(path);
  }

  List<RoomPhoto> _withRoomPhotoUrls(List<RoomPhoto> photos) => [
    for (final photo in photos)
      photo.copyWith(
        url: _supabase.storage
            .from(_roomPhotosBucket)
            .getPublicUrl(
              photo.path,
            ),
      ),
  ];

  Future<void> _removeRoomPhotoFile(String filePath) async {
    try {
      await _supabase.storage.from(_roomPhotosBucket).remove([filePath]);
    } on Object catch (error, stackTrace) {
      log(
        'Failed to remove an orphaned room photo file',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  String _roomPhotoExtension(String contentType) => switch (contentType) {
    'image/jpeg' => 'jpg',
    'image/png' => 'png',
    'image/webp' => 'webp',
    _ => throw FormatException('Unsupported image type: $contentType'),
  };

  Future<List<StudyMaterial>> getPublicMaterials({int limit = 50}) async {
    final res = await _supabase.rpc<Object?>(
      'list_public_materials_v2',
      params: {'p_organization_id': _organizationId, 'p_limit': limit},
    );
    return _mapRows(res, StudyMaterial.fromJson);
  }

  Future<List<MaterialAuthor>> getTopMaterialAuthors() async {
    final res = await _supabase.rpc<Object?>(
      'get_top_material_authors',
      params: {'p_organization_id': _organizationId},
    );
    return _mapRows(res, MaterialAuthor.fromJson);
  }

  Future<List<String>> searchMaterialSubjects(String query) async {
    final response = await _supabase.rpc<Object?>(
      'search_material_subjects',
      params: {
        'p_organization_id': _organizationId,
        'p_query': query.trim(),
        'p_limit': 40,
      },
    );
    if (response is! List || response.any((value) => value is! String)) {
      throw const FormatException('Material subjects must be a JSON array');
    }
    return response.cast<String>();
  }

  Future<String> createPublicMaterial({
    required String title,
    required String subjectName,
    List<String> subjectNames = const [],
    String materialType = 'note',
    int price = 0,
    int pages = 0,
    bool isAnonymous = false,
    String? fileName,
    Uint8List? fileBytes,
    String? mimeType,
    Uint8List? previewBytes,
    String? previewMimeType,
    int? width,
    int? height,
    int? durationSeconds,
    String? batchId,
  }) async {
    final trimmedTitle = title.trim();
    final subjects = <String>[
      ...{
        for (final value in subjectNames.isEmpty ? [subjectName] : subjectNames)
          if (value.trim().isNotEmpty) value.trim(),
      },
    ];
    if (trimmedTitle.isEmpty || trimmedTitle.length > 200) {
      throw ArgumentError(
        'A material title of up to 200 characters is required',
      );
    }
    if (subjects.isEmpty ||
        subjects.length > 10 ||
        subjects.any((value) => value.length > 300)) {
      throw ArgumentError('Choose up to 10 valid subjects');
    }
    if (fileBytes == null ||
        fileBytes.isEmpty ||
        fileBytes.length > 100 * 1024 * 1024 ||
        fileName?.trim().isEmpty != false) {
      throw ArgumentError('A material file is required');
    }
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      throw const AuthException('Sign in before uploading a material');
    }
    final filePath = '$userId/bank/${_randomMaterialObjectKey()}';
    await _supabase.storage
        .from('lesson-materials')
        .uploadBinary(
          filePath,
          fileBytes,
          fileOptions: FileOptions(
            contentType: mimeType ?? 'application/octet-stream',
          ),
        );
    String? previewPath;
    if (previewBytes != null && previewBytes.isNotEmpty) {
      previewPath = '$userId/bank/previews/${_randomMaterialObjectKey()}.jpg';
      try {
        await _supabase.storage
            .from('lesson-materials')
            .uploadBinary(
              previewPath,
              previewBytes,
              fileOptions: FileOptions(
                contentType: previewMimeType ?? 'image/jpeg',
              ),
            );
      } on Object catch (error, stackTrace) {
        log(
          'Failed to upload a material preview',
          error: error,
          stackTrace: stackTrace,
        );
        previewPath = null;
      }
    }
    try {
      final response = await _supabase.rpc<Object?>(
        'create_public_material_v3',
        params: {
          'p_organization_id': _organizationId,
          'p_title': trimmedTitle,
          'p_subject_names': subjects,
          'p_material_type': materialType,
          'p_price': price,
          'p_pages': pages,
          'p_is_anonymous': isAnonymous,
          'p_file_name': fileName,
          'p_file_path': filePath,
          'p_mime_type': mimeType,
          'p_file_size': fileBytes.length,
          'p_preview_path': previewPath,
          'p_width': width,
          'p_height': height,
          'p_duration_seconds': durationSeconds,
          'p_batch_id': batchId,
        },
      );
      return _parseUuid(response, 'create_public_material_v3');
    } on Object catch (error, stackTrace) {
      if (error is PostgrestException) {
        await _removeMaterialFile(filePath);
        final orphanedPreview = previewPath;
        if (orphanedPreview != null) {
          await _removeMaterialFile(orphanedPreview);
        }
      }
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> _removeMaterialFile(String filePath) async {
    try {
      await _supabase.storage.from('lesson-materials').remove([filePath]);
    } on Object catch (error, stackTrace) {
      log(
        'Failed to remove an orphaned material file',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> incrementMaterialDownloads(String id) async {
    await _supabase.rpc<Object?>(
      'increment_material_downloads',
      params: {'p_id': id},
    );
  }

  Future<({bool liked, int likes})> toggleMaterialLike(String id) async {
    final response = await _supabase.rpc<Object?>(
      'toggle_material_like',
      params: {'p_id': id},
    );
    if (response is! Map) {
      throw const FormatException('Invalid material like response');
    }
    final map = response.cast<String, Object?>();
    return (
      liked: map['liked'] as bool? ?? false,
      likes: (map['likes'] as num?)?.toInt() ?? 0,
    );
  }

  Future<Map<String, String>> createMaterialPreviewUrls(
    List<StudyMaterial> materials,
  ) async {
    final paths = <String>{
      for (final material in materials)
        if (material.previewPath?.isNotEmpty ?? false) material.previewPath!,
    }.toList(growable: false);
    if (paths.isEmpty) return const {};
    final results = await _supabase.storage
        .from('lesson-materials')
        .createSignedUrlsResult(paths, 60 * 30);
    return {
      for (final result in results)
        if (result is SignedUrlSuccess) result.path: result.signedUrl,
    };
  }

  Future<void> deleteOwnMaterial(String id) async {
    final response = await _supabase.rpc<Object?>(
      'delete_own_material',
      params: {'p_material_id': id},
    );
    if (response is! Map) {
      throw const FormatException('Invalid delete material response');
    }
    final paths = <String>[
      for (final key in const ['filePath', 'previewPath'])
        if (response[key] case final String path when path.isNotEmpty) path,
    ];
    if (paths.isEmpty) return;
    try {
      await _supabase.storage.from('lesson-materials').remove(paths);
    } on Object catch (error, stackTrace) {
      log(
        'Failed to remove storage files for a deleted material',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<String> createPublicMaterialUrl(StudyMaterial material) async {
    if (!material.hasFile) {
      throw const FormatException('Material does not have an attached file');
    }
    final access = await _supabase.rpc<Object?>(
      'access_public_material',
      params: {'p_id': material.id},
    );
    if (access is! Map) {
      throw const FormatException('Material access returned an invalid result');
    }
    if (!MaterialAccess.fromJson(access.cast()).canDownload) {
      throw const MaterialPurchaseException(.unavailable);
    }
    final filePath = access['filePath'];
    if (filePath is! String || filePath.isEmpty) {
      throw const FormatException('Material access returned an invalid path');
    }
    return _supabase.storage
        .from('lesson-materials')
        .createSignedUrl(filePath, 60 * 10);
  }

  Future<MaterialAccess> getPublicMaterialAccess(StudyMaterial material) async {
    final response = await _supabase.rpc<Object?>(
      'access_public_material',
      params: {'p_id': material.id},
    );
    if (response is! Map) {
      throw const FormatException('Invalid material access response');
    }
    return MaterialAccess.fromJson(response.cast());
  }

  Future<void> purchasePublicMaterial(
    StudyMaterial material, {
    required int expectedPrice,
  }) async {
    if (expectedPrice <= 0 || expectedPrice > 1000000) {
      throw ArgumentError.value(expectedPrice, 'expectedPrice');
    }
    try {
      final response = await _supabase.rpc<Object?>(
        'purchase_public_material',
        params: {'p_id': material.id, 'p_expected_price': expectedPrice},
      );
      if (response is! Map ||
          !MaterialAccess.fromJson(response.cast()).canDownload) {
        throw const FormatException('Material purchase was not confirmed');
      }
    } on PostgrestException catch (error) {
      throw MaterialPurchaseException(switch (error.message) {
        'MATERIAL_INSUFFICIENT_BALANCE' => .insufficientBalance,
        'MATERIAL_PRICE_CHANGED' => .priceChanged,
        _ => .unavailable,
      });
    }
  }

  Future<TeacherProfile> getTeacherProfile(String teacherName) async {
    final res = await _supabase.rpc<Object?>(
      'get_teacher_profile',
      params: {
        'p_organization_id': _organizationId,
        'p_teacher_name': teacherName,
      },
    );
    if (res is Map) {
      return TeacherProfile.fromJson(res.cast());
    }
    return TeacherProfile.empty;
  }

  Future<void> upsertTeacherReview({
    required String teacherName,
    required int clarity,
    required int loyalty,
    required int usefulness,
    String body = '',
    bool isAnonymous = false,
  }) async {
    await _supabase.rpc<Object?>(
      'upsert_teacher_review',
      params: {
        'p_organization_id': _organizationId,
        'p_teacher_name': teacherName,
        'p_clarity': clarity,
        'p_loyalty': loyalty,
        'p_usefulness': usefulness,
        'p_body': body,
        'p_is_anonymous': isAnonymous,
      },
    );
  }

  Future<List<CollabNote>> getGroupNotes() async {
    final res = await _supabase.rpc<Object?>(
      'get_group_notes',
      params: {'p_organization_id': _organizationId},
    );
    return _mapRows(res, CollabNote.fromJson);
  }

  Future<CollabNote?> getGroupNote(String noteId) async {
    final notes = await getGroupNotes();
    for (final note in notes) {
      if (note.id == noteId) return note;
    }
    return null;
  }

  Future<String> createGroupNote(
    String title, {
    CollabNoteVisibility visibility = .group,
  }) async {
    final res = await _supabase.rpc<Object?>(
      'create_group_note',
      params: {
        'p_organization_id': _organizationId,
        'p_title': title,
        'p_visibility': visibility.wireValue,
      },
    );
    if (res case final String id when id.isNotEmpty) return id;
    throw const FormatException('create_group_note returned an invalid id');
  }

  Future<GroupNoteSaveResult> saveGroupNote({
    required String id,
    required String title,
    required String content,
    required int expectedRevision,
  }) async {
    try {
      final res = await _supabase.rpc<Object?>(
        'save_group_note',
        params: {
          'p_id': id,
          'p_title': title,
          'p_content': content,
          'p_expected_revision': expectedRevision,
        },
      );
      if (res is Map) return GroupNoteSaveResult.fromJson(res.cast());
      throw const FormatException('save_group_note returned an invalid result');
    } on PostgrestException catch (error, stackTrace) {
      if (error.code == 'PT409') {
        Error.throwWithStackTrace(
          const CollabNoteConflictException(),
          stackTrace,
        );
      }
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> deleteGroupNote(String id) async {
    await _supabase.rpc<Object?>('delete_group_note', params: {'p_id': id});
  }

  Future<void> renameGroupNote(String id, String title) async {
    await _supabase.rpc<Object?>(
      'rename_group_note',
      params: {'p_id': id, 'p_title': title},
    );
  }

  Future<void> setGroupNoteVisibility(
    String id,
    CollabNoteVisibility visibility,
  ) async {
    await _supabase.rpc<Object?>(
      'set_group_note_visibility',
      params: {'p_id': id, 'p_visibility': visibility.wireValue},
    );
  }

  Future<GroupNoteDocumentSaveResult> saveGroupNoteDocument({
    required String id,
    required List<Object?> document,
    required int expectedRevision,
  }) async {
    try {
      final res = await _supabase.rpc<Object?>(
        'save_group_note_document',
        params: {
          'p_note_id': id,
          'p_document': document,
          'p_revision': expectedRevision,
        },
      );
      if (res is Map) return GroupNoteDocumentSaveResult.fromJson(res.cast());
      throw const FormatException(
        'save_group_note_document returned an invalid result',
      );
    } on PostgrestException catch (error, stackTrace) {
      if (error.code == '42501') {
        Error.throwWithStackTrace(
          const CollabNoteUnavailableException(),
          stackTrace,
        );
      }
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  CollabNotePresenceSession openGroupNotePresence({
    required String noteId,
    required String editorName,
  }) {
    return SupabaseCollabNotePresenceSession(
      channel: _supabase.channel(
        'group-note:$noteId',
        opts: const RealtimeChannelConfig(private: true),
      ),
      editorName: editorName,
    );
  }

  CollabNoteRealtimeSession openGroupNoteRealtime({
    required String noteId,
    required String editorName,
  }) {
    return SupabaseCollabNoteRealtimeSession(
      channel: _supabase.channel(
        'group-note:$noteId',
        opts: const RealtimeChannelConfig(private: true),
      ),
      editorName: editorName,
    );
  }

  Stream<void> watchGroupNotesList() {
    final controller = StreamController<void>.broadcast();
    final channel = _supabase.channel('group-notes-list:$_organizationId')
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'core',
        table: 'group_notes',
        callback: (payload) => controller.add(null),
      )
      ..subscribe();
    controller.onCancel = () => unawaited(channel.unsubscribe());
    return controller.stream;
  }

  Future<String> uploadNoteMedia({
    required Uint8List bytes,
    required String contentType,
    required String extension,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      throw const AuthException('Sign in before uploading media');
    }
    final path = '$userId/${_randomMaterialObjectKey()}.$extension';
    await _supabase.storage
        .from('note-media')
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: contentType),
        );
    return _supabase.storage.from('note-media').getPublicUrl(path);
  }

  static List<T> _mapRows<T>(
    Object? res,
    T Function(Map<String, Object?>) fromJson,
  ) {
    return decodeJsonRows(
      res,
      context: 'Supabase RPC response',
    ).map(fromJson).toList();
  }

  static String _parseUuid(Object? value, String operation) {
    if (value case final String id
        when RegExp(
          '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-'
          r'[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
        ).hasMatch(id)) {
      return id;
    }
    throw FormatException('$operation returned an invalid id');
  }
}

String _randomMaterialObjectKey() {
  final random = Random.secure();
  return List.generate(
    16,
    (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
}
