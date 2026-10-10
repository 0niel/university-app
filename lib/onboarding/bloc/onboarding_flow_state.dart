part of 'onboarding_flow_cubit.dart';

enum OnboardingStage { welcome, group, teacher, identity, settings }

enum OnboardingDraftOrigin { initial, restored, edited, saved }

enum OnboardingIdentityRequirement { required, skipped }

@freezed
abstract class OnboardingIdentityDraft with _$OnboardingIdentityDraft {
  const factory OnboardingIdentityDraft({
    String? name,
    String? handle,
    String? verifiedHandle,
    @Default(OnboardingDraftOrigin.initial) OnboardingDraftOrigin origin,
  }) = _OnboardingIdentityDraft;

  const OnboardingIdentityDraft._();

  bool get complete =>
      (name?.trim().isNotEmpty ?? false) &&
      (handle?.trim().isNotEmpty ?? false) &&
      handle?.trim() == verifiedHandle?.trim();
}

@freezed
abstract class OnboardingFlowState with _$OnboardingFlowState {
  const factory OnboardingFlowState({
    @Default(OnboardingStage.welcome) OnboardingStage stage,
    @Default(AccountRole.student) AccountRole role,
    @Default(OnboardingDraftOrigin.initial) OnboardingDraftOrigin roleOrigin,
    Group? group,
    @Default('') String groupQuery,
    @Default(OnboardingDraftOrigin.initial) OnboardingDraftOrigin groupOrigin,
    Teacher? teacher,
    @Default(OnboardingDraftOrigin.initial) OnboardingDraftOrigin teacherOrigin,
    @Default(OnboardingIdentityDraft()) OnboardingIdentityDraft identity,
    @Default(OnboardingIdentityRequirement.required)
    OnboardingIdentityRequirement identityRequirement,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus submission,
  }) = _OnboardingFlowState;

  const OnboardingFlowState._();

  bool get isTeacher => role == AccountRole.teacher;

  int get totalSteps =>
      identityRequirement == OnboardingIdentityRequirement.required ? 4 : 3;

  bool get busy => submission.isInProgressOrSuccess;
}
