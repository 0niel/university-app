import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required FirebaseMessaging firebaseMessaging,
  })  : _firebaseMessaging = firebaseMessaging,
        super(AppInitial()) {
    on<AppOpened>(_onAppOpened);
    on<RecieveInteractedMessage>(_onRecieveInteractedMessage);
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
    emit(InteractedMessageRecieved(discoursePostIdToOpen: int.tryParse(discoursePostId ?? '')));
  }

  Future<void> _onAppOpened(AppOpened event, Emitter<AppState> emit) async {
    await setupInteractedMessage(emit);
  }
}
