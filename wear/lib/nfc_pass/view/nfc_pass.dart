import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:wear/nfc_pass/nfc_pass.dart';
import 'package:wearable_rotary/wearable_rotary.dart' as wearable_rotary show rotaryEvents;
import 'package:wearable_rotary/wearable_rotary.dart' hide rotaryEvents;

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: CounterView(),
    );
  }
}

class CounterView extends StatefulWidget {
  CounterView({
    super.key,
    @visibleForTesting Stream<RotaryEvent>? rotaryEvents,
  }) : rotaryEvents = rotaryEvents ?? wearable_rotary.rotaryEvents;

  final Stream<RotaryEvent> rotaryEvents;

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final _watchConnectivity = WatchConnectivity();

  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  String? _passId;
  bool _isLoading = true;
  bool _isReachable = false;
  bool _isPaired = false;

  @override
  void initState() {
    super.initState();
    _listenStreams();
    _checkInitialData();
  }

  void _listenStreams() {
    _watchConnectivity.messageStream.listen((message) {
      if (message.containsKey('passId')) {
        setState(() {
          _passId = message['passId'] as String?;
          _secureStorage.write(key: 'nfc_pass_id', value: _passId);
          _isLoading = false;
        });
      }
    });

    _watchConnectivity.contextStream.listen((contextData) {
      if (contextData.containsKey('passId')) {
        setState(() {
          _passId = contextData['passId'] as String?;
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _checkInitialData() async {
    final paired = await _watchConnectivity.isPaired;
    final reachable = await _watchConnectivity.isReachable;
    final contextData = await _watchConnectivity.applicationContext;

    setState(() {
      _isPaired = paired;
      _isReachable = reachable;
      _passId = contextData['passId']?.toString();
      _isLoading = false;
    });

    if (_passId == null || _passId!.isEmpty) {
      await _requestPassId();
    }
  }

  Future<void> _requestPassId() async {
    setState(() => _isLoading = true);

    try {
      await _watchConnectivity.sendMessage({
        'action': 'requestPassId',
      });
    } catch (e) {
      debugPrint('Ошибка при запросе passId: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading ? const CircularProgressIndicator() : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (!_isPaired) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bluetooth_disabled, size: 48, color: Colors.red),
          SizedBox(height: 8),
          Text(
            'Часы не спарены с телефоном.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      );
    }
    if (_passId == null || _passId!.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network('https://lk.mirea.ru/local/templates/bootstrap_new/images/logo2018.png', width: 42),
          const SizedBox(height: 8),
          Text(
            'NFC-пропуск не найден на телефоне',
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Откройте приложение на телефоне и привяжите NFC-пропуск',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network('https://lk.mirea.ru/local/templates/bootstrap_new/images/logo2018.png', width: 42),
          const SizedBox(height: 8),
          Text(
            'NFC-пропуск найден',
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Приложите часы к считывателю',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
  }
}
