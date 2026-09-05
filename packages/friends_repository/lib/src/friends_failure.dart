sealed class FriendsFailure implements Exception {
  const FriendsFailure(this.error);

  final Object error;

  @override
  String toString() => 'Friends repository failure: $error';
}

final class GetGhostModeFailure extends FriendsFailure {
  const GetGhostModeFailure(super.error);
}

final class GetFriendsFailure extends FriendsFailure {
  const GetFriendsFailure(super.error);
}

final class GetMapStudentsFailure extends FriendsFailure {
  const GetMapStudentsFailure(super.error);
}

final class GetLocationVisibilityFailure extends FriendsFailure {
  const GetLocationVisibilityFailure(super.error);
}

final class SetLocationVisibilityFailure extends FriendsFailure {
  const SetLocationVisibilityFailure(super.error);
}

final class GetFriendRequestsFailure extends FriendsFailure {
  const GetFriendRequestsFailure(super.error);
}

final class SearchFriendsFailure extends FriendsFailure {
  const SearchFriendsFailure(super.error);
}

final class SendFriendRequestFailure extends FriendsFailure {
  const SendFriendRequestFailure(super.error);
}

final class RespondFriendRequestFailure extends FriendsFailure {
  const RespondFriendRequestFailure(super.error);
}

final class GetGroupMembersFailure extends FriendsFailure {
  const GetGroupMembersFailure(super.error);
}

final class GetFriendSuggestionsFailure extends FriendsFailure {
  const GetFriendSuggestionsFailure(super.error);
}

final class RemoveFriendFailure extends FriendsFailure {
  const RemoveFriendFailure(super.error);
}

final class PublishFriendLocationFailure extends FriendsFailure {
  const PublishFriendLocationFailure(super.error);
}

final class SetGhostModeFailure extends FriendsFailure {
  const SetGhostModeFailure(super.error);
}

final class SetLocationMoodFailure extends FriendsFailure {
  const SetLocationMoodFailure(super.error);
}

final class RegisterFriendDeviceFailure extends FriendsFailure {
  const RegisterFriendDeviceFailure(super.error);
}

final class UnregisterFriendDeviceFailure extends FriendsFailure {
  const UnregisterFriendDeviceFailure(super.error);
}

final class ScanWifiAccessPointsFailure extends FriendsFailure {
  const ScanWifiAccessPointsFailure(super.error);
}

final class ResolveWifiPositionFailure extends FriendsFailure {
  const ResolveWifiPositionFailure(super.error);
}

final class SubmitWifiObservationsFailure extends FriendsFailure {
  const SubmitWifiObservationsFailure(super.error);
}

final class FriendsResponseException extends FriendsFailure {
  const FriendsResponseException(super.error);
}
