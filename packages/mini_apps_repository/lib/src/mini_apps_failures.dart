import 'package:equatable/equatable.dart';

abstract class MiniAppsFailure with EquatableMixin implements Exception {
  const MiniAppsFailure(this.error);

  final Object error;

  @override
  List<Object?> get props => [error];
}

class GetMiniAppsFailure extends MiniAppsFailure {
  const GetMiniAppsFailure(super.error);
}

class GetMiniAppFailure extends MiniAppsFailure {
  const GetMiniAppFailure(super.error);
}

class GetMyMiniAppsFailure extends MiniAppsFailure {
  const GetMyMiniAppsFailure(super.error);
}

class SubmitMiniAppFailure extends MiniAppsFailure {
  const SubmitMiniAppFailure(super.error);
}

class UpdateMiniAppFailure extends MiniAppsFailure {
  const UpdateMiniAppFailure(super.error);
}

class DeleteMiniAppFailure extends MiniAppsFailure {
  const DeleteMiniAppFailure(super.error);
}

class GetMiniAppScreensFailure extends MiniAppsFailure {
  const GetMiniAppScreensFailure(super.error);
}

class ReportMiniAppFailure extends MiniAppsFailure {
  const ReportMiniAppFailure(super.error);
}

class SetMiniAppHiddenFailure extends MiniAppsFailure {
  const SetMiniAppHiddenFailure(super.error);
}

class SetMiniAppConsentsFailure extends MiniAppsFailure {
  const SetMiniAppConsentsFailure(super.error);
}

class RateMiniAppFailure extends MiniAppsFailure {
  const RateMiniAppFailure(super.error);
}

class FetchMiniAppScreenFailure extends MiniAppsFailure {
  const FetchMiniAppScreenFailure(super.error);
}

class CallMiniAppApiFailure extends MiniAppsFailure {
  const CallMiniAppApiFailure(super.error);
}

class MiniAppStorageFailure extends MiniAppsFailure {
  const MiniAppStorageFailure(super.error);
}

class GetMiniAppStatsFailure extends MiniAppsFailure {
  const GetMiniAppStatsFailure(super.error);
}

class GetRecentMiniAppsFailure extends MiniAppsFailure {
  const GetRecentMiniAppsFailure(super.error);
}

class MiniAppRevisionsFailure extends MiniAppsFailure {
  const MiniAppRevisionsFailure(super.error);
}

class MiniAppDeployTokenFailure extends MiniAppsFailure {
  const MiniAppDeployTokenFailure(super.error);
}

class MiniAppSigningSecretFailure extends MiniAppsFailure {
  const MiniAppSigningSecretFailure(super.error);
}

class MiniAppUploadFailure extends MiniAppsFailure {
  const MiniAppUploadFailure(super.error);
}

class ValidateMiniAppScreensFailure extends MiniAppsFailure {
  const ValidateMiniAppScreensFailure(super.error);
}

class SetMiniAppFeaturedFailure extends MiniAppsFailure {
  const SetMiniAppFeaturedFailure(super.error);
}

class GetModerationQueueFailure extends MiniAppsFailure {
  const GetModerationQueueFailure(super.error);
}

class ModerateMiniAppFailure extends MiniAppsFailure {
  const ModerateMiniAppFailure(super.error);
}

class ResolveMiniAppReportsFailure extends MiniAppsFailure {
  const ResolveMiniAppReportsFailure(super.error);
}
