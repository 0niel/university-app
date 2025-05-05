import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';
import 'package:app_ui/app_ui.dart';
import 'nfc_media_selector.dart';
import 'nfc_media_preview.dart';
import 'nfc_card_info.dart';

class NfcCardSettingsDialog extends StatelessWidget {
  const NfcCardSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NfcPassCubit, NfcPassState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title with explanation
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Настройка NFC-пропуска',
                      style: AppTextStyle.titleS.copyWith(fontWeight: FontWeight.w600),
                    ).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 8),
                    Text(
                      'Персонализируйте внешний вид вашего пропуска, выбрав изображение или видео для фона',
                      style: AppTextStyle.body.copyWith(color: Theme.of(context).extension<AppColors>()!.deactive),
                    ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                  ],
                ),
              ),

              // Media selector
              NfcMediaSelector(
                onSelectMedia: () => context.read<NfcPassCubit>().pickFile(),
                onRemoveMedia: state.localFilePath != null ? () => context.read<NfcPassCubit>().removeFile() : null,
                hasMedia: state.localFilePath != null,
                isVideo: state.isVideo,
              ),

              const SizedBox(height: 20),

              // Media preview
              NfcMediaPreview(filePath: state.localFilePath, isVideo: state.isVideo),

              const SizedBox(height: 20),

              // Card info (if bound)
              if (state.status == NfcPassStatus.bound) ...[
                NfcCardInfo(deviceId: state.passId?.toString()),
                const SizedBox(height: 20),
              ],

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(text: 'Готово', onPressed: () => Navigator.of(context).pop()),
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
