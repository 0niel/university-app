import 'package:equatable/equatable.dart';
import 'package:study_groups_repository/src/models/models.dart';
import 'package:supabase/supabase.dart';

/// {@template study_groups_repository}
/// Manages real student study groups on Supabase: creating a group (at most one
/// per user), inviting people (by handle or shareable code), join requests, and
/// membership. All group-space mechanics (posts, links, notes, members)
/// are scoped server-side to actual membership, not a self-declared string.
/// {@endtemplate}
class StudyGroupsRepository {
  /// {@macro study_groups_repository}
  const StudyGroupsRepository({
    required this.supabase,
    required this.organizationId,
  });

  /// Client used for all group RPC calls.
  final SupabaseClient supabase;

  /// Tenant identifier applied to organization-scoped operations.
  final String organizationId;

  /// The caller's group with roster, received invites and (if owner) requests.
  Future<MyStudyGroup> getMyGroup() async {
    try {
      final res = await supabase.rpc<Object?>(
        'get_my_study_group',
        params: {'p_organization_id': organizationId},
      );
      return _toMyGroup(res);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetMyStudyGroupFailure(error), stackTrace);
    }
  }

  /// Creates the caller's group. Fails if they already belong to one.
  Future<MyStudyGroup> createGroup({
    required String name,
    String emoji = '🎓',
    String description = '',
    bool isDiscoverable = true,
  }) async {
    try {
      final res = await supabase.rpc<Object?>(
        'create_study_group',
        params: {
          'p_organization_id': organizationId,
          'p_name': name,
          'p_emoji': emoji,
          'p_description': description,
          'p_discoverable': isDiscoverable,
        },
      );
      return _toMyGroup(res);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(CreateStudyGroupFailure(error), stackTrace);
    }
  }

  /// Owner-only: updates the group's editable fields (null keeps a field).
  Future<MyStudyGroup> updateGroup({
    String? name,
    String? emoji,
    String? description,
    bool? isDiscoverable,
  }) async {
    try {
      final res = await supabase.rpc<Object?>(
        'update_study_group',
        params: {
          'p_organization_id': organizationId,
          'p_name': name,
          'p_emoji': emoji,
          'p_description': description,
          'p_discoverable': isDiscoverable,
        },
      );
      return _toMyGroup(res);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(UpdateStudyGroupFailure(error), stackTrace);
    }
  }

  /// Owner-only: deletes the group and all its group-scoped content.
  Future<void> deleteGroup() async {
    try {
      await supabase.rpc<Object?>(
        'delete_study_group',
        params: {'p_organization_id': organizationId},
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DeleteStudyGroupFailure(error), stackTrace);
    }
  }

  /// Member-only: leaves the current group (owners must delete instead).
  Future<void> leaveGroup() async {
    try {
      await supabase.rpc<Object?>('leave_study_group');
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LeaveStudyGroupFailure(error), stackTrace);
    }
  }

  /// Owner-only: invites a user by id to join the group.
  Future<void> inviteByUserId(String userId) async {
    try {
      await supabase.rpc<Object?>(
        'invite_to_study_group',
        params: {'p_user_id': userId},
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(InviteMemberFailure(error), stackTrace);
    }
  }

  /// Owner-only: invites a user by their `@handle`.
  Future<void> inviteByHandle(String handle) async {
    try {
      await supabase.rpc<Object?>(
        'invite_to_study_group_by_handle',
        params: {'p_handle': handle},
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(InviteMemberFailure(error), stackTrace);
    }
  }

  /// Accepts or declines an invite addressed to the caller.
  Future<MyStudyGroup> respondInvite({
    required String inviteId,
    required bool accept,
  }) async {
    try {
      final res = await supabase.rpc<Object?>(
        'respond_group_invite',
        params: {'p_invite_id': inviteId, 'p_accept': accept},
      );
      return _toMyGroup(res);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(RespondInviteFailure(error), stackTrace);
    }
  }

  /// Joins a group immediately using its share code.
  Future<MyStudyGroup> joinByCode(String code) async {
    try {
      final res = await supabase.rpc<Object?>(
        'join_group_by_code',
        params: {'p_organization_id': organizationId, 'p_code': code},
      );
      return _toMyGroup(res);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(JoinGroupFailure(error), stackTrace);
    }
  }

  /// Sends a request to join a discoverable group (owner approves later).
  Future<void> requestToJoin(String groupId) async {
    try {
      await supabase.rpc<Object?>(
        'request_to_join_group',
        params: {'p_group_id': groupId},
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(RequestToJoinFailure(error), stackTrace);
    }
  }

  /// Owner-only: accepts or declines a pending join request.
  Future<MyStudyGroup> respondJoinRequest({
    required String inviteId,
    required bool accept,
  }) async {
    try {
      final res = await supabase.rpc<Object?>(
        'respond_join_request',
        params: {'p_invite_id': inviteId, 'p_accept': accept},
      );
      return _toMyGroup(res);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(RespondJoinRequestFailure(error), stackTrace);
    }
  }

  /// Owner-only: removes a member from the group.
  Future<void> removeMember(String userId) async {
    try {
      await supabase.rpc<Object?>(
        'remove_group_member',
        params: {'p_user_id': userId},
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(RemoveMemberFailure(error), stackTrace);
    }
  }

  /// Pending invites the caller has received (lightweight, for badges/CTA).
  Future<List<StudyGroupInvite>> getMyInvites() async {
    try {
      final res = await supabase.rpc<Object?>('get_my_group_invites');
      return _toList(res, StudyGroupInvite.fromJson);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetInvitesFailure(error), stackTrace);
    }
  }

  /// Searches discoverable groups in the org by name or code.
  Future<List<StudyGroupSummary>> searchGroups(String query) async {
    try {
      final res = await supabase.rpc<Object?>(
        'search_study_groups',
        params: {'p_organization_id': organizationId, 'p_query': query},
      );
      return _toList(res, StudyGroupSummary.fromJson);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SearchGroupsFailure(error), stackTrace);
    }
  }

  static MyStudyGroup _toMyGroup(Object? res) {
    if (res is Map) return MyStudyGroup.fromJson(res.cast());
    throw const FormatException('Study-group RPC must return a JSON object');
  }

  static List<T> _toList<T>(
    Object? res,
    T Function(Map<String, Object?>) fromJson,
  ) {
    if (res is! List) {
      throw const FormatException('Study-group RPC must return a JSON array');
    }
    return res.map((row) {
      if (row is! Map<Object?, Object?>) {
        throw const FormatException('Study-group row must be a JSON object');
      }
      return fromJson(row.cast());
    }).toList();
  }
}

/// {@template study_groups_failure}
/// Base failure for all [StudyGroupsRepository] operations.
/// {@endtemplate}
abstract class StudyGroupsFailure with EquatableMixin implements Exception {
  /// {@macro study_groups_failure}
  const StudyGroupsFailure(this.error);

  /// The underlying error that triggered this failure.
  final Object error;

  @override
  List<Object> get props => [error];
}

class GetMyStudyGroupFailure extends StudyGroupsFailure {
  const GetMyStudyGroupFailure(super.error);
}

class CreateStudyGroupFailure extends StudyGroupsFailure {
  const CreateStudyGroupFailure(super.error);
}

class UpdateStudyGroupFailure extends StudyGroupsFailure {
  const UpdateStudyGroupFailure(super.error);
}

class DeleteStudyGroupFailure extends StudyGroupsFailure {
  const DeleteStudyGroupFailure(super.error);
}

class LeaveStudyGroupFailure extends StudyGroupsFailure {
  const LeaveStudyGroupFailure(super.error);
}

class InviteMemberFailure extends StudyGroupsFailure {
  const InviteMemberFailure(super.error);
}

class RespondInviteFailure extends StudyGroupsFailure {
  const RespondInviteFailure(super.error);
}

class JoinGroupFailure extends StudyGroupsFailure {
  const JoinGroupFailure(super.error);
}

class RequestToJoinFailure extends StudyGroupsFailure {
  const RequestToJoinFailure(super.error);
}

class RespondJoinRequestFailure extends StudyGroupsFailure {
  const RespondJoinRequestFailure(super.error);
}

class RemoveMemberFailure extends StudyGroupsFailure {
  const RemoveMemberFailure(super.error);
}

class GetInvitesFailure extends StudyGroupsFailure {
  const GetInvitesFailure(super.error);
}

class SearchGroupsFailure extends StudyGroupsFailure {
  const SearchGroupsFailure(super.error);
}
