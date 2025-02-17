import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:rtu_mirea_app/app/theme/theme_mode.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  AppBloc({
    required FirebaseMessaging firebaseMessaging,
  })  : _firebaseMessaging = firebaseMessaging,
        super(const AppState()) {
    on<AppOpened>(_onAppOpened);
    on<RecieveInteractedMessage>(_onRecieveInteractedMessage);
    on<ThemeChanged>(_onThemeChanged);
  }

  final FirebaseMessaging _firebaseMessaging;

  Future<void> setupInteractedMessage(Emitter<AppState> emit) async {
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
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

  Future<void> _onRecieveInteractedMessage(RecieveInteractedMessage event, Emitter<AppState> emit) async {
    final data = event.message.data;
    Logger().i('Handling message: $data');
    final discoursePostId = data['discourse_post_id'] as String?;
    emit(state.copyWith(discoursePostIdToOpen: int.tryParse(discoursePostId ?? '')));
  }

  Future<void> _onAppOpened(AppOpened event, Emitter<AppState> emit) async {
    await setupInteractedMessage(emit);
  }

  Future<void> _onThemeChanged(ThemeChanged event, Emitter<AppState> emit) async {
    CustomThemeMode.setAmoled(event.isAmoled);
    emit(state.copyWith(isAmoled: event.isAmoled));
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    try {
      return AppState(
        isAmoled: json['isAmoled'] as bool? ?? false,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    try {
      return {
        'isAmoled': state.isAmoled,
      };
    } catch (_) {
      return null;
    }
  }
}
