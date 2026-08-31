import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:rtu_mirea_app/navigation/deep_links.dart';
import 'package:user_repository/user_repository.dart';

part 'app_event.dart';
part 'app_bloc.freezed.dart';
part 'app_state.dart';
part 'app_status.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  AppBloc({
    required this._firebaseMessaging,
    required this._userRepository,
    required User user,
    Future<void> Function()? onBeforeLogout,
  }) : super(
         user == .anonymous
             ? const AppState()
             : AppState(status: .authenticated, user: user),
       ) {
    _onBeforeLogout = onBeforeLogout;
    on<AppOpened>(_onAppOpened);
    on<InteractedMessageReceived>(_onInteractedMessageReceived);
    on<ThemeChanged>(_onThemeChanged);
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);

    _userSubscription = _userRepository.user.listen(_userChanged);
  }

  final UserRepository _userRepository;
  final FirebaseMessaging? _firebaseMessaging;
  late final Future<void> Function()? _onBeforeLogout;

  late StreamSubscription<User> _userSubscription;
  StreamSubscription<RemoteMessage>? _messageOpenedSubscription;
  var _isClosing = false;

  void _userChanged(User user) => add(AppUserChanged(user));

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    final user = event.user;
    final status = user == .anonymous
        ? AppStatus.unauthenticated
        : user.isNewUser
        ? AppStatus.onboardingRequired
        : AppStatus.authenticated;
    emit(state.copyWith(status: status, user: user));
  }

  Future<void> _onLogoutRequested(
    AppLogoutRequested _,
    Emitter<AppState> _,
  ) async {
    try {
      await _onBeforeLogout?.call();
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
    try {
      await _userRepository.logOut();
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  @override
  Future<void> close() async {
    _isClosing = true;
    await _messageOpenedSubscription?.cancel();
    await _userSubscription.cancel();
    return super.close();
  }

  Future<void> setupInteractedMessage() async {
    final messaging = _firebaseMessaging;
    if (messaging == null) return;

    try {
      final initialMessage = await messaging.getInitialMessage();
      if (_isClosing || isClosed) return;
      if (initialMessage != null) {
        _handleMessage(initialMessage);
      }
    } on MissingPluginException catch (error) {
      Logger().w('Firebase Messaging plugin is not available: $error');
      return;
    } on PlatformException catch (error) {
      Logger().w('Firebase Messaging channel error: $error');
      return;
    }

    if (_isClosing || isClosed) return;
    _messageOpenedSubscription ??= FirebaseMessaging.onMessageOpenedApp.listen(
      _handleMessage,
    );
  }

  void _handleMessage(RemoteMessage message) {
    add(InteractedMessageReceived(message));
  }

  void _onInteractedMessageReceived(
    InteractedMessageReceived event,
    Emitter<AppState> emit,
  ) {
    final data = event.message.data;
    Logger().i('Handling message: $data');
    final discoursePostId = data['discourse_post_id'] as String?;
    final route = DeepLinks.normalizeLocation(data['route'] as String?);
    emit(
      state.withNotificationDestination(
        discoursePostId: int.tryParse(discoursePostId ?? ''),
        route: route,
      ),
    );
  }

  Future<void> _onAppOpened(AppOpened _, Emitter<AppState> _) async {
    await setupInteractedMessage();
  }

  void _onThemeChanged(
    ThemeChanged event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(isAmoled: event.isAmoled));
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    final isAmoled = json['isAmoled'];
    if (isAmoled is! bool) return null;
    return state.copyWith(isAmoled: isAmoled);
  }

  @override
  Map<String, dynamic> toJson(AppState state) => {
    'isAmoled': state.isAmoled,
  };
}
