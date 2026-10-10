import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'onboarding_flow_state.dart';
part 'onboarding_flow_cubit.freezed.dart';

class OnboardingFlowCubit extends Cubit<OnboardingFlowState> {
  OnboardingFlowCubit({
    required this._repository,
    required this._organizationId,
    required String? Function() currentUserId,
    required bool Function() isGuest,
    required this._selectedGroup,
    AccountPersonaCubit? persona,
  }) : _currentUserId = currentUserId,
       _isGuest = isGuest,
       _persona = persona,
       _userId = currentUserId(),
       super(
         OnboardingFlowState(
           role: persona?.state.persona.role ?? AccountRole.student,
           teacher: persona?.state.persona.teacherAvailable == true
               ? persona?.state.teacher
               : null,
           identityRequirement: isGuest()
               ? OnboardingIdentityRequirement.skipped
               : OnboardingIdentityRequirement.required,
         ),
       );

  final GamificationRepository _repository;
  final String _organizationId;
  final String? Function() _currentUserId;
  final bool Function() _isGuest;
  final Group? Function() _selectedGroup;
  final AccountPersonaCubit? _persona;
  final String? _userId;
  Future<bool>? _restoring;

  bool get ownsSession => !isClosed && _currentUserId() == _userId;

  Future<bool> restore({required bool onboardingShown}) =>
      _restoring ??= _restore(onboardingShown: onboardingShown);

  Future<bool> _restore({required bool onboardingShown}) async {
    if (!ownsSession) return false;
    try {
      await _persona?.restore();
      if (!ownsSession) return false;
      await _repository.ensureAcademicProfile(_organizationId);
      if (!ownsSession) return false;
      final overview = await _repository
          .getProfileOverview(_organizationId)
          .timeout(const Duration(seconds: 8));
      if (!ownsSession || state.busy) return false;
      var restored = state;
      if (state.roleOrigin == OnboardingDraftOrigin.initial &&
          _persona != null) {
        final persona = _persona.state;
        restored = restored.copyWith(
          role: persona.persona.role,
        );
      }
      if (state.teacherOrigin == OnboardingDraftOrigin.initial &&
          _persona != null) {
        final persona = _persona.state;
        restored = restored.copyWith(
          teacher: persona.persona.teacherAvailable ? persona.teacher : null,
          teacherOrigin: OnboardingDraftOrigin.restored,
        );
      }
      if (state.identity.origin == OnboardingDraftOrigin.initial) {
        restored = restored.copyWith(
          identity: OnboardingIdentityDraft(
            name: overview.academic.fullName?.trim(),
            handle: overview.academic.handle?.trim(),
            verifiedHandle: overview.academic.handle?.trim(),
            origin: OnboardingDraftOrigin.restored,
          ),
        );
      }
      if (state.groupOrigin == OnboardingDraftOrigin.initial) {
        final savedGroup = overview.academic.group?.trim();
        final selected = _selectedGroup();
        final group =
            selected != null &&
                (savedGroup == null ||
                    savedGroup.isEmpty ||
                    selected.name == savedGroup)
            ? selected
            : savedGroup != null && savedGroup.isNotEmpty
            ? Group(name: savedGroup)
            : null;
        restored = restored.copyWith(
          group: group,
          groupQuery: group?.name ?? restored.groupQuery,
          groupOrigin: OnboardingDraftOrigin.restored,
        );
      }
      if (state.stage == OnboardingStage.welcome ||
          state.stage == OnboardingStage.group ||
          state.stage == OnboardingStage.teacher) {
        restored = restored.copyWith(
          identityRequirement: _isGuest() || restored.identity.complete
              ? OnboardingIdentityRequirement.skipped
              : OnboardingIdentityRequirement.required,
        );
      }
      emit(restored);
      return state.stage == OnboardingStage.welcome &&
          state.roleOrigin == OnboardingDraftOrigin.initial &&
          state.groupOrigin != OnboardingDraftOrigin.edited &&
          state.identity.complete &&
          (state.isTeacher
              ? _persona?.state.persona.teacherAvailable == true
              : (overview.academic.group?.trim().isNotEmpty ?? false)) &&
          _userId != null &&
          !onboardingShown &&
          !_isGuest();
    } on Exception catch (error, stackTrace) {
      log(
        'Onboarding identity preload failed',
        error: error,
        stackTrace: stackTrace,
        name: 'OnboardingFlowCubit',
      );
      return false;
    }
  }

  void _edit(OnboardingFlowState next) {
    if (!ownsSession || state.busy) return;
    emit(next.copyWith(submission: FormzSubmissionStatus.initial));
  }

  void start() => _edit(
    state.copyWith(
      stage: state.isTeacher ? OnboardingStage.teacher : OnboardingStage.group,
    ),
  );

  void startTeacher() => _edit(
    state.copyWith(
      role: AccountRole.teacher,
      roleOrigin: OnboardingDraftOrigin.edited,
      stage: OnboardingStage.teacher,
    ),
  );

  void startStudent() => _edit(
    state.copyWith(
      role: AccountRole.student,
      roleOrigin: OnboardingDraftOrigin.edited,
      stage: OnboardingStage.group,
    ),
  );

  void welcome() => _edit(state.copyWith(stage: OnboardingStage.welcome));

  void updateGroupQuery(String query) => _edit(
    state.copyWith(
      groupQuery: query,
      groupOrigin: OnboardingDraftOrigin.edited,
    ),
  );

  void selectGroup(Group? group) => _edit(
    state.copyWith(group: group, groupOrigin: OnboardingDraftOrigin.edited),
  );

  void selectTeacher(Teacher teacher) => _edit(
    state.copyWith(
      teacher: teacher,
      roleOrigin: OnboardingDraftOrigin.edited,
      teacherOrigin: OnboardingDraftOrigin.edited,
    ),
  );

  void afterSelection() => _edit(
    state.copyWith(
      stage: state.identityRequirement == OnboardingIdentityRequirement.required
          ? OnboardingStage.identity
          : OnboardingStage.settings,
    ),
  );

  void teacherLater() {
    _edit(
      state.copyWith(
        teacher: null,
        roleOrigin: OnboardingDraftOrigin.edited,
        teacherOrigin: OnboardingDraftOrigin.edited,
      ),
    );
    afterSelection();
  }

  void beforeIdentity() => _edit(
    state.copyWith(
      stage: state.isTeacher ? OnboardingStage.teacher : OnboardingStage.group,
    ),
  );

  void beforeSettings() => _edit(
    state.copyWith(
      stage: state.identityRequirement == OnboardingIdentityRequirement.required
          ? OnboardingStage.identity
          : state.isTeacher
          ? OnboardingStage.teacher
          : OnboardingStage.group,
    ),
  );

  void updateIdentity(String name, String handle) => _edit(
    state.copyWith(
      identity: state.identity.copyWith(
        name: name,
        handle: handle,
        origin: OnboardingDraftOrigin.edited,
      ),
    ),
  );

  void completeIdentity(String name, String handle) => _edit(
    state.copyWith(
      identity: OnboardingIdentityDraft(
        name: name,
        handle: handle,
        verifiedHandle: handle,
        origin: OnboardingDraftOrigin.saved,
      ),
      stage: OnboardingStage.settings,
    ),
  );

  Future<bool> prepareFinish() async {
    if (!ownsSession || state.busy) return false;
    final draft = state;
    emit(state.copyWith(submission: FormzSubmissionStatus.inProgress));
    try {
      await _repository.ensureAcademicProfile(
        _organizationId,
        academicGroup: draft.isTeacher ? null : draft.group?.name,
      );
      if (!ownsSession) return false;
      final saved = await _persona?.configure(
        role: draft.role,
        teacher: draft.isTeacher ? draft.teacher : null,
        clearTeacher: draft.isTeacher && draft.teacher == null,
      );
      if (!ownsSession) return false;
      emit(
        state.copyWith(
          submission: saved == false
              ? FormzSubmissionStatus.failure
              : FormzSubmissionStatus.success,
        ),
      );
      return saved != false;
    } on Exception catch (error, stackTrace) {
      log(
        'Onboarding profile initialization failed',
        error: error,
        stackTrace: stackTrace,
        name: 'OnboardingFlowCubit',
      );
      if (ownsSession) {
        emit(state.copyWith(submission: FormzSubmissionStatus.failure));
      }
      return false;
    } finally {
      if (!isClosed && state.submission == FormzSubmissionStatus.inProgress) {
        emit(state.copyWith(submission: FormzSubmissionStatus.canceled));
      }
    }
  }
}
