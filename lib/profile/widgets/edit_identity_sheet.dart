import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';

Future<void> showEditIdentitySheet(
  BuildContext context,
  AcademicProfile academic,
) {
  final cubit = context.read<ProfileCubit>();
  final repository = context.read<GamificationRepository>();
  final l10n = context.l10n;
  return showAppSheet<void>(
    context,
    title: l10n.profileEditIdentityTitle,
    subtitle: l10n.profileEditIdentitySubtitle,
    child: EditIdentitySheet(
      initialName: academic.fullName ?? '',
      initialHandle: academic.handle ?? '',
      onCheckAvailable: repository.isHandleAvailable,
      onSave: cubit.updateIdentity,
    ),
  );
}

class EditIdentitySheet extends StatefulWidget {
  const EditIdentitySheet({
    required this.initialName,
    required this.initialHandle,
    required this.onCheckAvailable,
    required this.onSave,
    super.key,
  });

  final String initialName;
  final String initialHandle;
  final Future<bool> Function(String handle) onCheckAvailable;
  final Future<IdentityUpdateResult> Function({
    required String fullName,
    required String handle,
  })
  onSave;

  @override
  State<EditIdentitySheet> createState() => _EditIdentitySheetState();
}

enum _HandleState { idle, checking, available, taken, invalid, failed }

class _EditIdentitySheetState extends State<EditIdentitySheet> {
  static final _handleRegex = RegExp(r'^[a-z0-9_]{3,20}$');

  late final TextEditingController _name;
  late final TextEditingController _handle;
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
    if (_handleRegex.hasMatch(widget.initialHandle)) {
      _state = .available;
    }
  }

  @override
  void dispose() {
    _request++;
    _debounce?.cancel();
    _name
      ..removeListener(_onNameChanged)
      ..dispose();
    _handle.dispose();
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
    } on Exception catch (error, stackTrace) {
      log(
        'Handle availability check failed',
        error: error,
        stackTrace: stackTrace,
        name: 'EditIdentitySheet',
      );
      if (mounted && request == _request) {
        setState(() => _state = .failed);
      }
    }
  }

  bool get _canSave => !_saving && _hasName && _state == .available;

  Future<void> _save() async {
    if (!_canSave) return;
    setState(() => _saving = true);
    final l10n = context.l10n;
    final result = await widget.onSave(
      fullName: _name.text.trim(),
      handle: _handle.text.trim(),
    );
    if (!mounted) return;
    switch (result) {
      case .success:
        Navigator.of(context).pop();
        showNinjaToast(context, message: l10n.profileIdentitySaved);
      case .handleTaken:
        setState(() {
          _state = .taken;
          _saving = false;
        });
      case .error:
        setState(() => _saving = false);
        showNinjaToast(
          context,
          message: l10n.identitySaveError,
          showCheck: false,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (String? error, String? helper) = switch (_state) {
      .taken => (l10n.identityHandleTaken, null),
      .invalid => (l10n.identityHandleInvalid, null),
      .failed => (l10n.identityHandleCheckError, null),
      .available => (null, l10n.identityHandleAvailable),
      .idle || .checking => (null, l10n.identityHandleHelp),
    };

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        AppInputField(
          controller: _name,
          enabled: !_saving,
          fillColor: context.colors.surface,
          label: l10n.identityNameLabel,
          placeholder: l10n.identityNameHint,
          textInputAction: .next,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        AppInputField(
          controller: _handle,
          enabled: !_saving,
          fillColor: context.colors.surface,
          label: l10n.identityHandleLabel,
          placeholder: l10n.identityHandleHint,
          leadingIcon: AppLineIcon.at,
          showClear: false,
          success: _state == .available,
          inputFormatters: [
            const _HandleEditFormatter(),
            LengthLimitingTextInputFormatter(20),
          ],
          onChanged: _onHandleChanged,
          errorText: error,
          helperText: helper,
        ),
        if (_state == .failed)
          AppButton(
            label: l10n.retry,
            variant: AppButtonVariant.text,
            onPressed: () => _onHandleChanged(_handle.text),
          ),
        const SizedBox(height: AppSpacing.fieldGap),
        AppButton.primary(
          label: _saving ? l10n.identitySaving : l10n.profileEditSave,
          expanded: true,
          size: .large,
          loading: _saving,
          onPressed: _canSave
              ? () {
                  unawaited(_save());
                }
              : null,
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
      selection: .collapsed(offset: filtered.length),
    );
  }
}
