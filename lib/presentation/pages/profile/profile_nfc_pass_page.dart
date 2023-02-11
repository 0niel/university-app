import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/domain/entities/nfc_pass.dart';
import 'package:rtu_mirea_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/nfc_pass_bloc/nfc_pass_bloc.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/colorful_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/icon_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/settings_button.dart';
import 'package:rtu_mirea_app/presentation/core/routes/routes.gr.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import '../../bloc/announces_bloc/announces_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../bloc/profile_bloc/profile_bloc.dart';
import '../../widgets/buttons/text_outlined_button.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:app_settings/app_settings.dart';

class ProfileNfcPassPage extends StatefulWidget {
  const ProfileNfcPassPage({Key? key}) : super(key: key);

  @override
  State<ProfileNfcPassPage> createState() => _ProfileNfcPageState();
}

class _ProfileNfcPageState extends State<ProfileNfcPassPage> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NFC-пропуск"),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                context.read<NfcPassBloc>().add(const NfcPassEvent.started());
                final student = state.user;
                return ListView(
                  children: [
                    const SizedBox(height: 24),
                    FutureBuilder<AndroidDeviceInfo>(
                      future: deviceInfo.androidInfo,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data == null) {
                            return const _ErrorAndroidDataFetch();
                          }
                          return BlocBuilder<NfcPassBloc, NfcPassState>(
                            builder: (context, state) => state.map(
                              initial: (_) {
                                context.read<NfcPassBloc>().add(
                                      NfcPassEvent.getNfcPasses(
                                        student.code,
                                        student.studentId,
                                        snapshot.data!.id,
                                      ),
                                    );
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              loading: (_) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              loaded: (state) {
                                if (state.nfcPasses.isEmpty) {
                                  return _NfcNotConnected(
                                    onPressed: () =>
                                        context.read<NfcPassBloc>().add(
                                              NfcPassEvent.connectNfcPass(
                                                student.code,
                                                student.studentId,
                                                snapshot.data!.id,
                                                snapshot.data!.model,
                                              ),
                                            ),
                                  );
                                }
                                return Column(
                                  children: [
                                    Text(
                                      "Подключенные устройства",
                                      style: AppTextStyle.title,
                                    ),
                                    const SizedBox(height: 16),
                                    // Сначала подключенные устройства
                                    for (final nfcPass in state.nfcPasses)
                                      if (nfcPass.connected)
                                        _NfcPassCard(
                                          nfcPass: nfcPass,
                                        ),
                                    // Потом остальные
                                    for (final nfcPass in state.nfcPasses)
                                      if (!nfcPass.connected)
                                        _NfcPassCard(
                                          nfcPass: nfcPass,
                                        ),
                                    const SizedBox(height: 16),
                                    // Если нет ни одного подключенного или подключенное устройство не текущее
                                    if (state.nfcPasses.every(
                                            (element) => !element.connected) ||
                                        state.nfcPasses.any((element) =>
                                            element.connected &&
                                            element.deviceId !=
                                                snapshot.data!.id))
                                      ColorfulButton(
                                        text: "Привязать это устройство",
                                        backgroundColor:
                                            AppTheme.colors.primary,
                                        onClick: () =>
                                            context.read<NfcPassBloc>().add(
                                                  NfcPassEvent.connectNfcPass(
                                                    student.code,
                                                    student.studentId,
                                                    snapshot.data!.id,
                                                    snapshot.data!.model,
                                                  ),
                                                ),
                                      ),
                                  ],
                                );
                              },
                              nfcDisabled: (_) =>
                                  const _NfcNotAviable(disabled: true),
                              nfcNotSupported: (_) =>
                                  const _NfcNotAviable(disabled: false),
                              error: (_) => const Center(
                                child: Text("Ошибка"),
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

// Виджет с иноформацией о том, что пропуск ещё не подключен ни к одному устройству
class _NfcNotConnected extends StatelessWidget {
  const _NfcNotConnected({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          "Пропуск не подключен",
          style: AppTextStyle.titleM,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          "Ваш NFC-пропуск ещё не подключен ни к одному устройству и не может быть использован. Чтобы подключить пропуск, нажмите на кнопку ниже.",
          style: AppTextStyle.body,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ColorfulButton(
          text: "Подключить пропуск",
          onClick: onPressed,
          backgroundColor: AppTheme.colors.primary,
        ),
      ],
    );
  }
}

class _ErrorAndroidDataFetch extends StatelessWidget {
  const _ErrorAndroidDataFetch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          "Не удалось получить данные об устройстве",
          style: AppTextStyle.titleM,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          "Приложение не может получить данные об устройстве. Попробуйте перезагрузить приложение или предоставить приложению нужные разрешения.",
          style: AppTextStyle.bodyL,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _NfcPassCard extends StatelessWidget {
  const _NfcPassCard({
    Key? key,
    required this.nfcPass,
  }) : super(key: key);

  final NfcPass nfcPass;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        color: AppTheme.colors.background02,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        margin: const EdgeInsets.all(0),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.nfc),
                  const SizedBox(width: 8),
                  Text(
                    "NFC-пропуск",
                    style: AppTextStyle.titleS,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "ID: ",
                    style: AppTextStyle.body,
                  ),
                  Text(
                    nfcPass.deviceId,
                    style: AppTextStyle.body,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "Модель: ",
                    style: AppTextStyle.body,
                  ),
                  Text(
                    nfcPass.deviceName,
                    style: AppTextStyle.body,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (nfcPass.connected)
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppTheme.colors.colorful04,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Это устройство подключено к пропуску",
                      style: AppTextStyle.body,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NfcNotAviable extends StatelessWidget {
  const _NfcNotAviable({Key? key, required this.disabled}) : super(key: key);

  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.error,
          color: AppTheme.colors.colorful07,
          size: 64,
        ),
        const SizedBox(height: 16),
        Text(
          disabled ? "NFC отключено" : "Ваше устройство не поддерживает NFC",
          style: AppTextStyle.titleM,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          disabled
              ? "Включите NFC в настройках вашего устройства"
              : "Ваше устройство не поддерживает NFC. Пропуск по NFC недоступен",
          style: AppTextStyle.bodyL,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        if (disabled)
          TextOutlinedButton(
            content: "Включить NFC",
            onPressed: () {
              AppSettings.openNFCSettings();
            },
          ),
      ],
    );
  }
}
