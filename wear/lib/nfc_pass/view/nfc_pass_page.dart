import 'dart:async';

import 'package:flutter/material.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class NfcPassPage extends StatefulWidget {
  const NfcPassPage({super.key});

  @override
  State<NfcPassPage> createState() => _NfcPassPageState();
}

class _NfcPassPageState extends State<NfcPassPage> {
  final _watchConnectivity = WatchConnectivity();
  StreamSubscription<Map<String, dynamic>>? _messageSubscription;
  StreamSubscription<Map<String, dynamic>>? _contextSubscription;

  String? _passId;
  bool _isLoading = true;
  bool _isPaired = false;

  @override
  void initState() {
    super.initState();
    _listenToPassUpdates();
    unawaited(_checkInitialData());
  }

  @override
  void dispose() {
    unawaited(_messageSubscription?.cancel() ?? Future.value());
    unawaited(_contextSubscription?.cancel() ?? Future.value());
    super.dispose();
  }

  void _listenToPassUpdates() {
    _messageSubscription = _watchConnectivity.messageStream.listen(
      _applyPassData,
      onError: _logWatchError,
    );
    _contextSubscription = _watchConnectivity.contextStream.listen(
      _applyPassData,
      onError: _logWatchError,
    );
  }

  void _applyPassData(Map<String, Object?> data) {
    final passId = data['passId'];
    if (!mounted || passId is! String) return;
    setState(() {
      _passId = passId;
      _isLoading = false;
    });
  }

  Future<void> _checkInitialData() async {
    try {
      final paired = await _watchConnectivity.isPaired;
      final contextData = await _watchConnectivity.applicationContext;
      if (!mounted) return;
      final passId = contextData['passId'];
      setState(() {
        _isPaired = paired;
        _passId = passId is String ? passId : null;
        _isLoading = false;
      });
      if (_passId case null || '') unawaited(_requestPassId());
    } on Exception catch (error) {
      _logWatchError(error);
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _requestPassId() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      await _watchConnectivity.sendMessage({'action': 'requestPassId'});
    } on Exception catch (error) {
      _logWatchError(error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _logWatchError(Object error) =>
      debugPrint('NFC pass watch synchronization failed: $error');

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
          Text('Часы не спарены с телефоном.'),
        ],
      );
    }

    final hasPass = _passId?.isNotEmpty ?? false;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(hasPass ? Icons.nfc : Icons.badge_outlined, size: 42),
        const SizedBox(height: 8),
        Text(
          hasPass ? 'NFC-пропуск найден' : 'NFC-пропуск не найден на телефоне',
          style: Theme.of(context).textTheme.titleSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          hasPass
              ? 'Приложите часы к считывателю'
              : 'Откройте приложение на телефоне и привяжите NFC-пропуск',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
