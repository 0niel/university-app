import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/widgets/widgets.dart';

enum _HandleCheck { idle, checking, available, taken, invalid, failed }

class OnboardingIdentityStep extends StatefulWidget {
  const OnboardingIdentityStep({
    required this.step,
    required this.totalSteps,
    required this.onBack,
    required this.onNext,
    this.initialName,
    this.initialHandle,
    super.key,
  });

  final int step;
  final int totalSteps;
  final VoidCallback onBack;
  final void Function(String name, String handle) onNext;
  final String? initialName;
  final String? initialHandle;

  @override
  State<OnboardingIdentityStep> createState() => _OnboardingIdentityStepState();
}

class _OnboardingIdentityStepState extends State<OnboardingIdentityStep> {
  static final _handleRegex = RegExp(r'^[a-z0-9_]{3,20}$');

  final _name = TextEditingController();
  final _handle = TextEditingController();
  Timer? _debounce;
  _HandleCheck _check = _HandleCheck.idle;
  var _saving = false;
  var _hasName = false;
  var _availabilityRequest = 0;
  var _nameDirty = false;
  var _handleDirty = false;

  GamificationRepository get _repo => context.read();

  String _authName() {
    try {
      return context.read<AppBloc>().state.user.name?.trim() ?? '';
    } on ProviderNotFoundException {
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    final savedName = widget.initialName?.trim() ?? '';
    _name.text = savedName.isNotEmpty ? savedName : _authName();
    _hasName = _name.text.trim().isNotEmpty;
    final savedHandle = widget.initialHandle?.trim() ?? '';
    if (savedHandle.isNotEmpty) {
      _handle.text = savedHandle;
      _check = _HandleCheck.available;
    }
  }

  @override
  void didUpdateWidget(covariant OnboardingIdentityStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextName = widget.initialName?.trim() ?? '';
    if (!_nameDirty && nextName.isNotEmpty && nextName != _name.text) {
      _name.text = nextName;
      _hasName = true;
    }
    final nextHandle = widget.initialHandle?.trim() ?? '';
    if (!_handleDirty && nextHandle.isNotEmpty && nextHandle != _handle.text) {
      _handle.text = nextHandle;
      _check = _HandleCheck.available;
    }
  }

  @override
  void dispose() {
    _availabilityRequest++;
    _debounce?.cancel();
    _name.dispose();
    _handle.dispose();
    super.dispose();
  }

  void _onNameChanged(String value) {
    _nameDirty = true;
    setState(() => _hasName = value.trim().isNotEmpty);
  }

  void _onHandleChanged(String value) {
    _handleDirty = true;
    _debounce?.cancel();
    _availabilityRequest++;
    final handle = value.trim();
    if (handle.isEmpty) {
      setState(() => _check = _HandleCheck.idle);
      return;
    }
    if (!_handleRegex.hasMatch(handle)) {
      setState(() => _check = _HandleCheck.invalid);
      return;
    }
    if (handle == widget.initialHandle?.trim()) {
      setState(() => _check = _HandleCheck.available);
      return;
    }
    setState(() => _check = _HandleCheck.checking);
    final request = _availabilityRequest;
    _debounce = Timer(const Duration(milliseconds: 400), () {
      unawaited(_checkHandle(handle, request));
    });
  }

  Future<void> _checkHandle(String handle, int request) async {
    try {
      final isAvailable = await _repo.isHandleAvailable(handle);
      if (!mounted || request != _availabilityRequest) return;
      if (_handle.text.trim() != handle) return;
      setState(
        () =>
            _check = isAvailable ? _HandleCheck.available : _HandleCheck.taken,
      );
    } on Exception catch (error, stackTrace) {
      log(
        'Handle availability check failed',
        error: error,
        stackTrace: stackTrace,
        name: 'OnboardingIdentityStep',
      );
      if (mounted && request == _availabilityRequest) {
        setState(() => _check = _HandleCheck.failed);
      }
    }
  }

  bool get _canSubmit =>
      !_saving && _hasName && _check == _HandleCheck.available;

  Future<void> _save() async {
    if (!_canSubmit) return;
    final name = _name.text.trim();
    final handle = _handle.text.trim();
    setState(() => _saving = true);
    try {
      await _repo.setUserIdentity(
        organizationId: context.read<UniversityConfig>().organizationId,
        fullName: name,
        handle: handle,
      );
      if (mounted) widget.onNext(name, handle);
    } on HandleTakenException {
      if (mounted) {
        setState(() {
          _check = _HandleCheck.taken;
          _saving = false;
        });
      }
    } on Exception {
      if (mounted) {
        setState(() => _saving = false);
        ToastManager.showError(
          context,
          message: context.l10n.identitySaveError,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (String? error, String? helper) = switch (_check) {
      _HandleCheck.taken => (l10n.identityHandleTaken, null),
      _HandleCheck.invalid => (l10n.identityHandleInvalid, null),
      _HandleCheck.available => (null, l10n.identityHandleAvailable),
      _HandleCheck.failed => (null, null),
      _HandleCheck.idle ||
      _HandleCheck.checking => (null, l10n.identityHandleHelp),
    };
    return AuthPageLayout(
      step: widget.step,
      totalSteps: widget.totalSteps,
      title: l10n.onboardingIdentityTitle,
      subtitle: l10n.onboardingIdentitySubtitle,
      onBack: widget.onBack,
      actions: AppButton.primary(
        key: const Key('onboarding_identityContinue'),
        label: _saving ? l10n.identitySaving : l10n.onboardingContinue,
        size: AppButtonSize.hero,
        expanded: true,
        loading: _saving,
        onPressed: _canSubmit ? () => unawaited(_save()) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppInputField(
            key: const Key('onboarding_identityName'),
            controller: _name,
            enabled: !_saving,
            label: l10n.identityNameLabel,
            placeholder: l10n.identityNameHint,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            onChanged: _onNameChanged,
          ),
          const SizedBox(height: 16),
          AppInputField(
            key: const Key('onboarding_identityHandle'),
            controller: _handle,
            enabled: !_saving,
            label: l10n.identityHandleLabel,
            placeholder: l10n.identityHandleHint,
            leadingIcon: AppLineIcon.at,
            trailing: _check == _HandleCheck.checking
                ? const AppSpinner(size: 18)
                : null,
            showClear: false,
            success: _check == _HandleCheck.available,
            inputFormatters: [
              const _HandleInputFormatter(),
              LengthLimitingTextInputFormatter(20),
            ],
            onChanged: _onHandleChanged,
            errorText: error,
            helperText: helper,
          ),
          if (_check == _HandleCheck.failed) ...[
            const SizedBox(height: 12),
            AppBanner(
              message: l10n.identityHandleCheckError,
              tone: AppBannerTone.warn,
              actionLabel: l10n.retry,
              onAction: () => _onHandleChanged(_handle.text),
            ),
          ],
        ],
      ),
    );
  }
}

class _HandleInputFormatter extends TextInputFormatter {
  const _HandleInputFormatter();

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
