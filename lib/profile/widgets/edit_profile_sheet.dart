import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_extras_cubit.dart';

Future<void> showEditProfileSheet(BuildContext context) {
  final cubit = context.read<ProfileCubit>();
  final extras = context.read<ProfileExtrasCubit>();
  final repository = context.read<GamificationRepository>();
  final academic = cubit.state.overview.academic;
  final l10n = context.l10n;
  return showAppSheet<void>(
    context,
    title: l10n.profile,
    child: EditProfileSheet(
      initialName: academic.fullName ?? cubit.state.user.name ?? '',
      initialHandle: academic.handle ?? '',
      initialAbout: extras.state.about,
      initialTelegram: extras.state.telegram,
      onCheckAvailable: repository.isHandleAvailable,
      onSave: cubit.updateIdentity,
      onSaveExtras: extras.setBio,
    ),
  );
}

typedef SaveExtras =
    void Function({
      required String about,
      required String telegram,
    });

class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({
    required this.initialName,
    required this.initialHandle,
    required this.initialAbout,
    required this.initialTelegram,
    required this.onCheckAvailable,
    required this.onSave,
    required this.onSaveExtras,
    super.key,
  });

  final String initialName;
  final String initialHandle;
  final String initialAbout;
  final String initialTelegram;
  final Future<bool> Function(String handle) onCheckAvailable;
  final Future<IdentityUpdateResult> Function({
    required String fullName,
    required String handle,
  })
  onSave;
  final SaveExtras onSaveExtras;

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

enum _HandleState { idle, checking, available, taken, invalid, failed }

class _EditProfileSheetState extends State<EditProfileSheet> {
  static final _handleRegex = RegExp(r'^[a-z0-9_]{3,20}$');
  late final TextEditingController _name;
  late final TextEditingController _handle;
  late final TextEditingController _about;
  late final TextEditingController _telegram;
  Timer? _debounce;
  var _request = 0;
  _HandleState _state = .idle;
  var _saving = false;
  var _hasName = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initialName)
      ..addListener(_onNameChanged);
    _hasName = _name.text.trim().isNotEmpty;
    _handle = TextEditingController(text: widget.initialHandle);
    _about = TextEditingController(text: widget.initialAbout);
    _telegram = TextEditingController(text: widget.initialTelegram);
    if (_handleRegex.hasMatch(widget.initialHandle)) _state = .available;
  }

  @override
  void dispose() {
    _request++;
    _debounce?.cancel();
    _name
      ..removeListener(_onNameChanged)
      ..dispose();
    _handle.dispose();
    _about.dispose();
    _telegram.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    setState(() => _hasName = _name.text.trim().isNotEmpty);
  }

  void _onHandleChanged(String value) {
    _debounce?.cancel();
    _request++;
    final handle = value.trim();
    if (handle.isEmpty) {
      setState(() => _state = .idle);
      return;
    }
    if (!_handleRegex.hasMatch(handle)) {
      setState(() => _state = .invalid);
      return;
    }
    if (handle == widget.initialHandle) {
      setState(() => _state = .available);
      return;
    }
    setState(() => _state = .checking);
    final request = _request;
    _debounce = Timer(const Duration(milliseconds: 400), () {
      unawaited(_checkHandle(handle, request));
    });
  }

  Future<void> _checkHandle(String handle, int request) async {
    try {
      final isAvailable = await widget.onCheckAvailable(handle);
      if (!mounted || request != _request || _handle.text.trim() != handle) {
        return;
      }
      setState(() => _state = isAvailable ? .available : .taken);
    } on Exception {
      if (mounted && request == _request) setState(() => _state = .failed);
    }
  }

  bool get _identityChanged =>
      _name.text.trim() != widget.initialName ||
      _handle.text.trim() != widget.initialHandle;

  bool get _canSave =>
      !_saving && _hasName && (_state == .available || !_identityChanged);

  Future<void> _save() async {
    if (!_canSave) return;
    setState(() => _saving = true);
    final l10n = context.l10n;
    if (!_identityChanged) {
      widget.onSaveExtras(about: _about.text, telegram: _telegram.text);
      ToastManager.showSuccess(context, message: l10n.profileUpdatedToast);
      Navigator.of(context).pop();
      return;
    }
    final result = await widget.onSave(
      fullName: _name.text.trim(),
      handle: _handle.text.trim(),
    );
    if (!mounted) return;
    switch (result) {
      case .success:
        widget.onSaveExtras(about: _about.text, telegram: _telegram.text);
        ToastManager.showSuccess(context, message: l10n.profileUpdatedToast);
        Navigator.of(context).pop();
      case .handleTaken:
        setState(() {
          _state = .taken;
          _saving = false;
        });
      case .error:
        setState(() => _saving = false);
        ToastManager.showError(context, message: l10n.identitySaveError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final (String? error, String? helper) = switch (_state) {
      .taken => (l10n.identityHandleTaken, null),
      .invalid => (l10n.identityHandleInvalid, null),
      .failed => (l10n.identityHandleCheckError, null),
      .available => (null, l10n.identityHandleAvailable),
      .idle || .checking => (null, l10n.identityHandleHelp),
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: AppAvatar(name: _name.text, size: 88)),
        const SizedBox(height: AppSpacing.fieldGap),
        AppInputField(
          controller: _name,
          enabled: !_saving,
          label: l10n.profileEditName,
          placeholder: l10n.identityNameHint,
          fillColor: colors.surface,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: AppSpacing.gap),
        AppInputField(
          controller: _handle,
          enabled: !_saving,
          label: l10n.identityHandleLabel,
          placeholder: l10n.identityHandleHint,
          leadingIcon: AppLineIcon.at,
          fillColor: colors.surface,
          showClear: false,
          success: _state == .available,
          inputFormatters: [
            const _HandleEditFormatter(),
            LengthLimitingTextInputFormatter(20),
          ],
          onChanged: _onHandleChanged,
          errorText: error,
          helperText: helper,
          textInputAction: TextInputAction.next,
        ),
        if (_state == .failed)
          AppButton(
            label: l10n.retry,
            variant: AppButtonVariant.text,
            onPressed: () => _onHandleChanged(_handle.text),
          ),
        const SizedBox(height: AppSpacing.gap),
        Text(
          l10n.profileLocalFieldsNote,
          style: AppText.caption.copyWith(color: colors.muted),
        ),
        const SizedBox(height: AppSpacing.gap),
        AppInputField(
          controller: _about,
          enabled: !_saving,
          label: l10n.profileEditAbout,
          placeholder: l10n.profileEditAboutHint,
          fillColor: colors.surface,
          maxLength: 120,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: AppSpacing.gap),
        AppInputField(
          controller: _telegram,
          enabled: !_saving,
          label: l10n.profileEditTelegram,
          placeholder: l10n.profileEditTelegramHint,
          fillColor: colors.surface,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => unawaited(_save()),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton.primary(
          label: l10n.profileEditSave,
          size: AppButtonSize.large,
          expanded: true,
          loading: _saving,
          onPressed: _canSave ? () => unawaited(_save()) : null,
        ),
      ],
    );
  }
}

class _HandleEditFormatter extends TextInputFormatter {
  const _HandleEditFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final filtered = newValue.text.toLowerCase().replaceAll(
      RegExp('[^a-z0-9_]'),
      '',
    );
    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}
