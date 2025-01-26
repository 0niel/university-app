import 'dart:io' as io;
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';
import 'package:app_ui/app_ui.dart';

class NfcCardSettingsDialog extends StatelessWidget {
  const NfcCardSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NfcPassCubit, NfcPassState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              _FilePicker(state: state),
              const SizedBox(height: 16),
              _Preview(state: state),
            ],
          ),
        );
      },
    );
  }
}

class _FilePicker extends StatelessWidget {
  final NfcPassState state;

  const _FilePicker({required this.state});

  @override
  Widget build(BuildContext context) {
    final hasFile = state.localFilePath != null;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: PlatformTextButton(
              material: (_, __) => MaterialTextButtonData(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).extension<AppColors>()!.background03,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              cupertino: (_, __) => CupertinoTextButtonData(
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).extension<AppColors>()!.background03,
              ),
              onPressed: () => context.read<NfcPassCubit>().pickFile(),
              child: const Text(
                '+',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        if (hasFile) ...[
          const SizedBox(width: 4),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                context.read<NfcPassCubit>().removeFile();
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _Preview extends StatelessWidget {
  final NfcPassState state;

  const _Preview({required this.state});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: state.localFilePath == null
          ? Text(
              "Текущий фон: голубой (по умолчанию)",
              style: AppTextStyle.body,
              textAlign: TextAlign.center,
              key: const ValueKey('default_text'),
            )
          : !state.isVideo
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    io.File(state.localFilePath!),
                    height: 150,
                    fit: BoxFit.cover,
                    key: const ValueKey('image_preview'),
                  ),
                )
              : Text(
                  "Выбрано видео",
                  style: AppTextStyle.body.copyWith(color: Theme.of(context).extension<AppColors>()!.active),
                  textAlign: TextAlign.center,
                  key: const ValueKey('video_text'),
                ),
    );
  }
}
