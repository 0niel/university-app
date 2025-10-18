import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:rtu_mirea_app/app/theme/theme_mode.dart';
import 'package:user_repository/user_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  AppBloc({
    required FirebaseMessaging firebaseMessaging,
    required UserRepository userRepository,
    required User user,
  }) : _firebaseMessaging = firebaseMessaging,
       _userRepository = userRepository,
       super(
         user == User.anonymous
             ? const AppState.unauthenticated()
             : AppState.authenticated(user),
       ) {
    on<AppOpened>(_onAppOpened);
    on<RecieveInteractedMessage>(_onRecieveInteractedMessage);
    on<ThemeChanged>(_onThemeChanged);
    on<AppUserChanged>(_onUserChanged);

    _userSubscription = _userRepository.user.listen(_userChanged);
  }

  final UserRepository _userRepository;
  final FirebaseMessaging _firebaseMessaging;

  late StreamSubscription<User> _userSubscription;

  void _userChanged(User user) => add(AppUserChanged(user));

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    final user = event.user;

    switch (state.status) {
      case AppStatus.onboardingRequired:
      case AppStatus.authenticated:
      case AppStatus.unauthenticated:
        return user != User.anonymous && user.isNewUser
            ? emit(AppState.onboardingRequired(user))
            : user == User.anonymous
            ? emit(const AppState.unauthenticated())
            : emit(AppState.authenticated(user));
    }
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_userRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  Future<void> setupInteractedMessage(Emitter<AppState> emit) async {
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(emit, initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(emit, message);
    });
  }

  void _handleMessage(Emitter<AppState> emit, RemoteMessage message) {
    add(RecieveInteractedMessage(message));
  }

  Future<void> _onRecieveInteractedMessage(
    RecieveInteractedMessage event,
    Emitter<AppState> emit,
  ) async {
    final data = event.message.data;
    Logger().i('Handling message: $data');
    final discoursePostId = data['discourse_post_id'] as String?;
    emit(
      state.copyWith(
        discoursePostIdToOpen: int.tryParse(discoursePostId ?? ''),
      ),
    );
  }

  Future<void> _onAppOpened(AppOpened event, Emitter<AppState> emit) async {
    await setupInteractedMessage(emit);
  }

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<AppState> emit,
  ) async {
    CustomThemeMode.setAmoled(event.isAmoled);
    emit(state.copyWith(isAmoled: event.isAmoled));
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    try {
      return AppState(
        isAmoled: json['isAmoled'] as bool? ?? false,
        status: AppStatus.values[json['status'] as int? ?? 0],
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    try {
      return {'isAmoled': state.isAmoled, 'status': state.status.index};
    } catch (_) {
      return null;
    }
  }
}
