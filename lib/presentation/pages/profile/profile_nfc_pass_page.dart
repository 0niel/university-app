import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rtu_mirea_app/domain/entities/nfc_pass.dart';
import 'package:rtu_mirea_app/presentation/bloc/nfc_feedback_bloc/nfc_feedback_bloc.dart';

import 'package:rtu_mirea_app/presentation/bloc/nfc_pass_bloc/nfc_pass_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/colorful_button.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_button.dart';

import '../../widgets/buttons/text_outlined_button.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:app_settings/app_settings.dart';

import 'package:flutter/cupertino.dart';

class ProfileNfcPassPage extends StatefulWidget {
  const ProfileNfcPassPage({Key? key}) : super(key: key);

  @override
  State<ProfileNfcPassPage> createState() => _ProfileNfcPageState();
}

class _ProfileNfcPageState extends State<ProfileNfcPassPage> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  void _showSnackBarLoadInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Загружаем пропуск в устройство"),
      ),
    );
  }

  bool _showMyDevices = false;

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
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              state.whenOrNull(
                  logInSuccess: (user) => context
                      .read<NfcPassBloc>()
                      .add(const NfcPassEvent.started()));

              return state.maybeMap(
                logInSuccess: (state) {
                  final user = state.user;
                  var student = UserBloc.getActiveStudent(user);

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
                            return BlocConsumer<NfcPassBloc, NfcPassState>(
                              listener: (context, state) {
                                state.whenOrNull(
                                  loaded: (nfcPasses) {
                                    if (!NfcPassBloc.isNfcFetched) {
                                      // If current device is not connected to
                                      // any nfc pass
                                      if (!nfcPasses.any((element) =>
                                          element.connected &&
                                          element.deviceId ==
                                              snapshot.data!.id)) {
                                        return;
                                      }

                                      _showSnackBarLoadInfo();
                                      context.read<NfcPassBloc>().add(
                                          const NfcPassEvent.fetchNfcCode());
                                    }
                                  },
                                );
                              },
                              builder: (context, state) => state.map(
                                initial: (_) {
                                  context.read<NfcPassBloc>().add(
                                        NfcPassEvent.getNfcPasses(
                                          student.code,
                                          student.id,
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
                                  final connectedDevice = state.nfcPasses
                                      .firstWhereOrNull((element) =>
                                          element.connected &&
                                          element.deviceId ==
                                              snapshot.data!.id);

                                  if (state.nfcPasses.isEmpty) {
                                    return _NfcNotConnected(
                                      onPressed: () =>
                                          context.read<NfcPassBloc>().add(
                                                NfcPassEvent.connectNfcPass(
                                                  student.code,
                                                  student.id,
                                                  snapshot.data!.id,
                                                  snapshot.data!.model,
                                                ),
                                              ),
                                    );
                                  }
                                  if (!_showMyDevices &&
                                      connectedDevice != null) {
                                    return _NfcPassCard(
                                      deviceId: connectedDevice.deviceId,
                                      deviceName: connectedDevice.deviceName,
                                      onClick: () {
                                        setState(() {
                                          _showMyDevices = true;
                                        });
                                      },
                                    );
                                  } else {
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
                                            _NfcPassDeviceCard(
                                              nfcPass: nfcPass,
                                            ),
                                        // Потом остальные
                                        for (final nfcPass in state.nfcPasses)
                                          if (!nfcPass.connected)
                                            _NfcPassDeviceCard(
                                              nfcPass: nfcPass,
                                            ),
                                        const SizedBox(height: 16),
                                        // Если нет ни одного подключенного или подключенное устройство не текущее
                                        if (state.nfcPasses.every((element) =>
                                                !element.connected) ||
                                            state.nfcPasses.any((element) =>
                                                element.connected &&
                                                element.deviceId !=
                                                    snapshot.data!.id))
                                          ColorfulButton(
                                            text:
                                                "Привязать пропуск к этому устройству",
                                            backgroundColor:
                                                AppTheme.colors.primary,
                                            onClick: () {
                                              context.read<NfcPassBloc>().add(
                                                    NfcPassEvent.connectNfcPass(
                                                      student.code,
                                                      student.id,
                                                      snapshot.data!.id,
                                                      snapshot.data!.model,
                                                    ),
                                                  );
                                            },
                                          ),
                                      ],
                                    );
                                  }
                                },
                                nfcDisabled: (_) =>
                                    const _NfcNotAviable(disabled: true),
                                nfcNotSupported: (_) =>
                                    const _NfcNotAviable(disabled: false),
                                error: (st) => Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Произошла ошибка:",
                                        style: AppTextStyle.titleM,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        st.cause,
                                        style: AppTextStyle.body,
                                      ),
                                    ],
                                  ),
                                ),
                                nfcNotExist: (_) => BlocBuilder<NfcFeedbackBloc,
                                    NfcFeedbackState>(
                                  builder: (context, state) => state.map(
                                    initial: (_) {
                                      final fullName =
                                          "${user.name} ${user.secondName.replaceAll(" ", "").isNotEmpty ? "${user.secondName} " : ""}${user.lastName}";

                                      return _NfcPassNotExistOnAccount(
                                        onClick: () => context
                                            .read<NfcFeedbackBloc>()
                                            .add(
                                              NfcFeedbackEvent.sendFeedback(
                                                fullName: fullName,
                                                group: student.academicGroup,
                                                personalNumber:
                                                    student.personalNumber,
                                                studentId:
                                                    student.id.toString(),
                                              ),
                                            ),
                                        fullName: fullName,
                                        personalNumber: student.personalNumber,
                                      );
                                    },
                                    loading: (_) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    success: (state) =>
                                        // Сообщение о том что заявка на привязку пропуска отправлена
                                        Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: AppTheme.colors.colorful04,
                                          size: 48,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          "Заявка на привязку пропуска отправлена",
                                          style: AppTextStyle.title,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          "Подождите, пока администратор подтвердит вашу заявку. "
                                          "Время ожидания может занять до 7 рабочих дней",
                                          style: AppTextStyle.body,
                                        ),
                                      ],
                                    ),
                                    failure: (st) => Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Произошла ошибка:",
                                            style: AppTextStyle.titleM,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            st.message,
                                            style: AppTextStyle.body,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
                },
                orElse: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NfcPassCard extends StatelessWidget {
  const _NfcPassCard(
      {Key? key,
      required this.deviceId,
      required this.deviceName,
      required this.onClick})
      : super(key: key);

  final String deviceId;
  final String deviceName;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          "Приложите телефон\nк турникету",
          style: AppTextStyle.titleM,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          width: 200,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppTheme.colors.active,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: const Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 16,
                left: 16,
                child: Image.asset(
                  "assets/icons/gerb.ico",
                  width: 32,
                  height: 32,
                ),
              ),
              Positioned(
                top: 64,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Transform.rotate(
                    angle: pi / 2,
                    child: Icon(
                      CupertinoIcons.radiowaves_left,
                      color: AppTheme.colors.background02,
                      size: 80,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ID",
                      style: AppTextStyle.titleM.copyWith(
                          color: AppTheme.colors.background01,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      deviceId,
                      style: AppTextStyle.titleM.copyWith(
                          color: AppTheme.colors.background01,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 16),
                    // device
                    Text(
                      "Устройство",
                      style: AppTextStyle.titleM.copyWith(
                          color: AppTheme.colors.background01,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      deviceName,
                      style: AppTextStyle.titleM.copyWith(
                          color: AppTheme.colors.background01,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppTheme.colors.colorful04,
              ),
              child: Icon(
                CupertinoIcons.checkmark_alt,
                size: 16,
                color: AppTheme.colors.background01,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Это устройство зарегистрировано как основное",
                      style: AppTextStyle.titleM),
                  const SizedBox(height: 4),
                  Text(
                    "Пропуск работает только на одном устройстве. "
                    "При входе на другом устройстве, пропуск на этом будет "
                    "отключен!",
                    style: AppTextStyle.body,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
        PrimaryButton(
          onClick: onClick,
          text: "Мои устройства",
        ),
      ],
    );
  }
}

class _NfcPassNotExistOnAccount extends StatelessWidget {
  const _NfcPassNotExistOnAccount({
    Key? key,
    required this.onClick,
    required this.fullName,
    required this.personalNumber,
  }) : super(key: key);

  final VoidCallback onClick;
  final String fullName;
  final String personalNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          "Пропуск не привязан к вашей учетной записи",
          style: AppTextStyle.title,
        ),
        const SizedBox(height: 16),
        Text(
          "Ваш NFC-пропуск не привязан к вашей учетной записи и не может быть использован в данный момент.\n\n"
          "Чтобы привязать пропуск к вашей учетной записи, необходимо оставить заявку.\n\n"
          "Время обработки - до 7 рабочих дней, после чего ваш NFC-пропуск будет автоматически активирован, "
          " а эта ошибка больше не будет отображаться.",
          style: AppTextStyle.body,
        ),
        const SizedBox(height: 36),
        Text(
          "Информация о заявке",
          style: AppTextStyle.titleM,
        ),
        const SizedBox(height: 8),
        Text(
          "Имя: $fullName",
          style: AppTextStyle.bodyL,
        ),
        const SizedBox(height: 4),
        Text(
          "Персональный номер: $personalNumber",
          style: AppTextStyle.bodyL,
        ),
        const SizedBox(height: 16),
        ColorfulButton(
          text: "Оставить заявку",
          backgroundColor: AppTheme.colors.primary,
          onClick: onClick,
        ),
      ],
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

class _NfcPassDeviceCard extends StatelessWidget {
  const _NfcPassDeviceCard({
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
              AppSettings.openAppSettings(type: AppSettingsType.nfc);
            },
          ),
      ],
    );
  }
}
