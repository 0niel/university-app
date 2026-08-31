import 'dart:developer';
import 'dart:math' show Random;
import 'dart:typed_data';

import 'package:campus_repository/src/collab_note_presence_session.dart';
import 'package:campus_repository/src/json_rows.dart';
import 'package:campus_repository/src/models/campus_models.dart';
import 'package:campus_repository/src/supabase_collab_note_presence_session.dart';
import 'package:supabase/supabase.dart';

/// Campus life on Supabase: group space (links, notes, fund, birthdays),
/// anonymous confessions and campus events with RSVPs. All reads/writes go
/// through `public.*` RPC wrappers; RLS scopes group data to the caller's
/// academic group.
class CampusRepository {
  factory CampusRepository({
    required SupabaseClient supabase,
    required String organizationId,
  }) => CampusRepository._(supabase, organizationId);

  const CampusRepository._(this._supabase, this._organizationId);

  final SupabaseClient _supabase;
  final String _organizationId;

  // ── Group space ────────────────────────────────────────────────────────────

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

  /// Searches the caller's group-space posts by title/body for global search
  /// (`search_group_posts` RPC; RLS scopes results to the academic group).
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

  /// Logs a committed global-search query (feeds «Часто ищут сейчас»).
  /// Best-effort: short queries are ignored server-side too.
  Future<void> logSearchQuery(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) return;
    await _supabase.rpc<Object?>(
      'log_search_query',
      params: {'p_query': trimmed},
    );
  }

  /// Top global-search queries across users over the last 7 days
  /// (`trending_searches` RPC).
  Future<List<TrendingSearch>> getTrendingSearches() async {
    final res = await _supabase.rpc<Object?>('trending_searches');
    return decodeJsonRows(
      res,
      context: 'trending_searches',
    ).map(TrendingSearch.fromJson).toList();
  }

  /// Loads community polls with their options, live vote counts and the
  /// caller's own selection (`get_polls` RPC).
  Future<List<Poll>> getPolls({int limit = 50, int offset = 0}) async {
    final res = await _supabase.rpc<Object?>(
      'get_polls',
      params: {
        'p_organization_id': _organizationId,
        'p_limit': limit,
        'p_offset': offset,
      },
    );
    if (res is! List) return const [];
    return res
        .whereType<Map<Object?, Object?>>()
        .map((e) => Poll.fromJson(e.cast()))
        .toList();
  }

  /// Creates a poll with at least two [options]; [correctIndex] marks the
  /// right answer for [PollType.quiz].
  Future<void> createPoll({
    required String question,
    required List<String> options,
    PollType type = .single,
    bool isAnonymous = false,
    bool showResults = true,
    DateTime? expiresAt,
    int? correctIndex,
  }) async {
    await _supabase.rpc<Object?>(
      'create_poll',
      params: {
        'p_organization_id': _organizationId,
        'p_question': question,
        'p_options': options,
        'p_poll_type': type.wire,
        'p_is_anonymous': isAnonymous,
        'p_show_results': showResults,
        'p_expires_at': expiresAt?.toUtc().toIso8601String(),
        'p_correct_index': correctIndex,
      },
    );
  }

  /// Casts the caller's vote(s); replaces any previous selection for the poll.
  Future<void> votePoll({
    required String pollId,
    required List<String> optionIds,
  }) async {
    await _supabase.rpc<Object?>(
      'vote_poll',
      params: {'p_poll_id': pollId, 'p_option_ids': optionIds},
    );
  }

  /// Deletes a poll the caller authored.
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

  // ── Events ─────────────────────────────────────────────────────────────────

  Future<List<CampusEvent>> getEvents() async {
    final res = await _supabase.rpc<Object?>(
      'get_events',
      params: {'p_organization_id': _organizationId},
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

  // ── Marketplace ────────────────────────────────────────────────────────────

  Future<List<MarketListing>> getListings() async {
    final res = await _supabase.rpc<Object?>(
      'get_listings',
      params: {'p_organization_id': _organizationId},
    );
    return _mapRows(res, MarketListing.fromJson);
  }

  Future<String> createListing({
    required String title,
    required int price,
    String category = 'other',
    String emoji = '📦',
    String description = '',
    bool showContact = false,
  }) async {
    final response = await _supabase.rpc<Object?>(
      'create_listing',
      params: {
        'p_organization_id': _organizationId,
        'p_title': title,
        'p_price': price,
        'p_category': category,
        'p_emoji': emoji,
        'p_description': description,
        'p_show_contact': showContact,
      },
    );
    return _parseUuid(response, 'create_listing');
  }

  Future<void> setListingSold({required String id, required bool sold}) async {
    await _supabase.rpc<Object?>(
      'set_listing_sold',
      params: {'p_id': id, 'p_sold': sold},
    );
  }

  Future<void> deleteListing(String id) async {
    await _supabase.rpc<Object?>('delete_listing', params: {'p_id': id});
  }

  // ── Mentorship ─────────────────────────────────────────────────────────────

  Future<List<Mentor>> getMentors() async {
    final res = await _supabase.rpc<Object?>(
      'get_mentors',
      params: {'p_organization_id': _organizationId},
    );
    return _mapRows(res, Mentor.fromJson);
  }

  Future<void> upsertMentorProfile({
    required List<String> topics,
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

  // ── Teams ──────────────────────────────────────────────────────────────────

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

  // ── Free rooms ─────────────────────────────────────────────────────────────

  Future<List<FreeRoom>> getFreeRooms() async {
    final res = await _supabase.rpc<Object?>(
      'get_free_rooms',
      params: {'p_organization_id': _organizationId},
    );
    return _mapRows(res, FreeRoom.fromJson);
  }

  // ── Knowledge bank ─────────────────────────────────────────────────────────

  Future<List<StudyMaterial>> getPublicMaterials({int limit = 50}) async {
    final res = await _supabase.rpc<Object?>(
      'get_public_materials',
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

  Future<void> createPublicMaterial({
    required String title,
    required String subjectName,
    String materialType = 'note',
    int price = 0,
    int pages = 0,
    bool isAnonymous = false,
    String? fileName,
    Uint8List? fileBytes,
    String? mimeType,
  }) async {
    if (fileBytes == null ||
        fileBytes.isEmpty ||
        fileName?.trim().isEmpty != false) {
      throw ArgumentError('A material file is required');
    }
    final filePath = 'bank/${_randomMaterialObjectKey()}';
    await _supabase.storage
        .from('lesson-materials')
        .uploadBinary(
          filePath,
          fileBytes,
          fileOptions: FileOptions(
            contentType: mimeType ?? 'application/octet-stream',
          ),
        );
    try {
      await _supabase.rpc<Object?>(
        'create_public_material',
        params: {
          'p_organization_id': _organizationId,
          'p_title': title,
          'p_subject_name': subjectName,
          'p_material_type': materialType,
          'p_price': price,
          'p_pages': pages,
          'p_is_anonymous': isAnonymous,
          'p_file_name': fileName,
          'p_file_path': filePath,
          'p_mime_type': mimeType,
          'p_file_size': fileBytes.length,
        },
      );
    } on Exception catch (error, stackTrace) {
      if (filePath.isNotEmpty) await _removeMaterialFile(filePath);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> _removeMaterialFile(String filePath) async {
    try {
      await _supabase.storage.from('lesson-materials').remove([filePath]);
    } on Exception catch (error, stackTrace) {
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
    final filePath = access['filePath'];
    if (filePath is! String || filePath.isEmpty) {
      throw const FormatException('Material access returned an invalid path');
    }
    return _supabase.storage
        .from('lesson-materials')
        .createSignedUrl(filePath, 60 * 10);
  }

  // ── Teacher profile ────────────────────────────────────────────────────────

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

  // ── Collab notes ───────────────────────────────────────────────────────────

  Future<List<CollabNote>> getGroupNotes() async {
    final res = await _supabase.rpc<Object?>(
      'get_group_notes',
      params: {'p_organization_id': _organizationId},
    );
    return _mapRows(res, CollabNote.fromJson);
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

  // ── Helpers ────────────────────────────────────────────────────────────────

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
