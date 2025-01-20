import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';

class WatchConnectivityWrapper extends StatefulWidget {
  const WatchConnectivityWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<WatchConnectivityWrapper> createState() => _WatchConnectivityWrapperState();
}

class _WatchConnectivityWrapperState extends State<WatchConnectivityWrapper> {
  late final WatchConnectivity _watchConnectivity;
  late final NfcPassCubit _nfcPassCubit;

  @override
  void initState() {
    super.initState();

    _watchConnectivity = WatchConnectivity();

    _nfcPassCubit = context.read<NfcPassCubit>();

    _watchConnectivity.messageStream.listen((message) async {
      final action = message['action'];
      switch (action) {
        case 'requestPassId':
          _sendPassIdToWatch();
          break;
        case 'openPhoneAppForBinding':
          debugPrint('Часы запросили открыть экран привязки NFC');
          break;
        default:
          debugPrint('Неизвестный action: $action');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NfcPassCubit, NfcPassState>(
      listenWhen: (previous, current) => previous.passId != current.passId,
      listener: (context, state) {
        _sendPassIdToWatch();
      },
      child: widget.child,
    );
  }

  void _sendPassIdToWatch() async {
    final state = _nfcPassCubit.state;
    final passId = state.passId;

    final data = {'passId': passId?.toString() ?? ''};

    try {
      await _watchConnectivity.sendMessage(data);
      debugPrint('Отправили passId = ${data['passId']} на часы (sendMessage)');
    } catch (e) {
      debugPrint('Не удалось отправить сообщение на часы: $e');
    }

    try {
      await _watchConnectivity.updateApplicationContext(data);
      debugPrint('Обновили applicationContext passId = ${data['passId']}');
    } catch (e) {
      debugPrint('Не удалось обновить applicationContext: $e');
    }
  }
}
