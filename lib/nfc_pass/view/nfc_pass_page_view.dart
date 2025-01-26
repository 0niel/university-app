import 'dart:io' as io;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/widgets/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:app_ui/app_ui.dart';

class NfcPassPageView extends StatefulWidget {
  const NfcPassPageView({super.key});

  @override
  State<NfcPassPageView> createState() => _NfcPassPageViewState();
}

class _NfcPassPageViewState extends State<NfcPassPageView> {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<NfcPassCubit>().checkBound();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _openSettings() async {
    await BottomModalSheet.show(
      context,
      child: const NfcCardSettingsDialog(),
      title: 'Настройки карточки',
      description: 'Выберите видео или изображение, которое будет отображаться на карточке',
    );
  }

  Future<void> _showCodeInputSheet() async {
    await BottomModalSheet.show(
      context,
      title: 'Код из письма',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SixDigitCodeInput(
            onCompleted: (code) async {
              final deviceName = await _getDeviceName();

              if (!mounted) return;

              context.read<NfcPassCubit>().confirmBinding(
                    sixDigitCode: code,
                    deviceName: deviceName,
                  );

              context.pop();
            },
          ).animate().fadeIn(duration: 500.ms),
        ],
      ).animate().fadeIn(duration: 500.ms),
    );
  }

  Future<String> _getDeviceName() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      final info = await deviceInfo.androidInfo;
      return info.model;
    } catch (e) {
      return 'Unknown device';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NfcPassCubit, NfcPassState>(
      listener: (context, state) {
        if (state.status == NfcPassStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: ${state.errorMessage}')),
          );
        } else if (state.status == NfcPassStatus.codeSent) {
          _showCodeInputSheet();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("NFC-пропуск"),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: _openSettings,
              ),
            ],
          ),
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  ).animate().fadeIn(duration: 500.ms);
                },
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: _buildBody(state),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(NfcPassState state) {
    if (state.status == NfcPassStatus.loading) {
      return const Center(child: CircularProgressIndicator()).animate().fadeIn(duration: 300.ms);
    }

    switch (state.status) {
      case NfcPassStatus.initial:
        return Center(
          child: NfcNotConnected(
            onPressed: () => context.read<NfcPassCubit>().bindPass(),
          ).animate().fadeIn(duration: 500.ms),
        );

      case NfcPassStatus.codeSent:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedMail02,
                size: 64,
                color: AppColors.light.colorful04,
              ).animate().scale(
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  ),
              const SizedBox(height: 24),
              Text(
                'Сервис журнала отправил вам код на почту, привязанную к студенческому аккаунту. Пожалуйста, введите его.',
                style: AppTextStyle.body,
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
              SizedBox(height: MediaQuery.of(context).size.height / 4),
            ],
          ).animate().fadeIn(duration: 500.ms),
        );

      case NfcPassStatus.bound:
        return ListView(
          key: const ValueKey('bound'),
          children: [
            const SizedBox(height: 24),
            FutureBuilder<String>(
              future: _getDeviceName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return NfcPassCard(
                      deviceId: state.passId?.toString() ?? 'Unknown ID',
                      deviceName: snapshot.data ?? 'Unknown device',
                      localFilePath: state.localFilePath,
                      isVideo: state.isVideo,
                      videoController: _buildVideoController(state.localFilePath, state.isVideo),
                      initializeVideoFuture: _initializeVideoFuture(state.localFilePath, state.isVideo),
                      onClick: () {
                        context.read<NfcPassCubit>().unbindPass();
                      },
                    ).animate().fadeIn(duration: 500.ms);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ).animate().fadeIn(duration: 500.ms);

      case NfcPassStatus.error:
        return _buildErrorUi(state.errorMessage).animate().shake(duration: 500.ms);

      default:
        return const SizedBox();
    }
  }

  VideoPlayerController? _buildVideoController(String? path, bool isVideo) {
    if (path != null && isVideo) {
      return VideoPlayerController.file(
        io.File(path),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      )
        ..setVolume(0)
        ..setLooping(true);
    }
    return null;
  }

  Future<void>? _initializeVideoFuture(String? path, bool isVideo) {
    final controller = _buildVideoController(path, isVideo);
    if (controller != null) {
      return controller.initialize().then((_) {
        controller.play();
      });
    }
    return null;
  }

  Widget _buildErrorUi(String? error) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error, size: 48, color: Colors.red).animate().shake(duration: 500.ms),
        const SizedBox(height: 16),
        Text(
          'Произошла ошибка.\n${error ?? "Неизвестная ошибка"}',
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 500.ms),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => context.read<NfcPassCubit>().checkBound(),
          child: const Text('Повторить'),
        ).animate().scale(duration: 500.ms),
      ],
    );
  }
}

class NfcNotConnected extends StatelessWidget {
  const NfcNotConnected({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HugeIcon(icon: HugeIcons.strokeRoundedConnect, size: 64, color: AppColors.dark.colorful04)
            .animate()
            .fadeIn(duration: 500.ms),
        const SizedBox(height: 16),
        Text(
          "Пропуск не подключен",
          style: AppTextStyle.titleM,
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 500.ms),
        const SizedBox(height: 8),
        Text(
          "Ваш NFC-пропуск ещё не подключен устройству и не может быть использован",
          style: AppTextStyle.body,
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
        const SizedBox(height: 16),
        ColorfulButton(
          text: "Подключить пропуск",
          onClick: onPressed,
          backgroundColor: AppColors.dark.primary,
        ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
      ],
    );
  }
}

class ErrorAndroidDataFetch extends StatelessWidget {
  const ErrorAndroidDataFetch({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          "Не удалось получить данные об устройстве",
          style: AppTextStyle.titleM,
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 500.ms),
        const SizedBox(height: 16),
        Text(
          "Приложение не может получить данные об устройстве. Попробуйте перезагрузить приложение или предоставить приложению нужные разрешения.",
          style: AppTextStyle.bodyL,
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
      ],
    );
  }
}
