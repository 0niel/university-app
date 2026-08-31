part of '../view/onboarding_page.dart';

class _IdentityStep extends StatefulWidget {
  const _IdentityStep({
    required this.onBack,
    required this.onNext,
    this.initialName,
    this.initialHandle,
    super.key,
  });

  final VoidCallback onBack;
  final void Function(String name, String handle) onNext;

  final String? initialName;
  final String? initialHandle;

  @override
  State<_IdentityStep> createState() => _IdentityStepState();
}

class _IdentityStepState extends State<_IdentityStep> {
  static final _handleRegex = RegExp(r'^[a-z0-9_]{3,20}$');

  final _name = TextEditingController();
  final _handle = TextEditingController();
  Timer? _debounce;
  _HandleCheck _check = .idle;
  var _saving = false;
  var _hasName = false;
  var _availabilityRequest = 0;
  var _nameDirty = false;
  var _handleDirty = false;

  GamificationRepository get _repo => context.read();

  @override
  void initState() {
    super.initState();
    final savedName = widget.initialName?.trim() ?? '';
    final authName = context.read<AppBloc>().state.user.name?.trim() ?? '';
    _name.text = savedName.isNotEmpty ? savedName : authName;
    _hasName = _name.text.trim().isNotEmpty;

    final savedHandle = widget.initialHandle?.trim() ?? '';
    if (savedHandle.isNotEmpty) {
      _handle.text = savedHandle;
      _check = .available;
    }
  }

  @override
  void didUpdateWidget(covariant _IdentityStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextName = widget.initialName?.trim() ?? '';
    if (!_nameDirty && nextName.isNotEmpty && nextName != _name.text) {
      _name.text = nextName;
      _hasName = true;
    }
    final nextHandle = widget.initialHandle?.trim() ?? '';
    if (!_handleDirty && nextHandle.isNotEmpty && nextHandle != _handle.text) {
      _handle.text = nextHandle;
      _check = .available;
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
      setState(() => _check = .idle);
      return;
    }
    if (!_handleRegex.hasMatch(handle)) {
      setState(() => _check = .invalid);
      return;
    }
    if (handle == widget.initialHandle?.trim()) {
      setState(() => _check = .available);
      return;
    }
    setState(() => _check = .checking);
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
      setState(() => _check = isAvailable ? .available : .taken);
    } on Exception catch (error, stackTrace) {
      log(
        'Handle availability check failed',
        error: error,
        stackTrace: stackTrace,
        name: 'OnboardingIdentityStep',
      );
      if (mounted && request == _availabilityRequest) {
        setState(() => _check = .idle);
      }
    }
  }

  bool get _canSubmit => !_saving && _hasName && _check == .available;

  Future<void> _save() async {
    if (!_canSubmit) return;
    setState(() => _saving = true);
    try {
      await _repo.setUserIdentity(
        organizationId: context.read<UniversityConfig>().organizationId,
        fullName: _name.text.trim(),
        handle: _handle.text.trim(),
      );
      if (mounted) {
        widget.onNext(_name.text.trim(), _handle.text.trim());
      }
    } on HandleTakenException {
      if (mounted) {
        setState(() {
          _check = .taken;
          _saving = false;
        });
      }
    } on Exception {
      if (mounted) {
        setState(() => _saving = false);
        showNinjaToast(
          context,
          message: context.l10n.identitySaveError,
          showCheck: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _OnboardStep(
      step: 2,
      total: 3,
      showBack: true,
      onBack: widget.onBack,
      ctaLabel: _saving ? l10n.identitySaving : l10n.onboardingNext,
      ctaEnabled: _canSubmit,
      ctaLoading: _saving,
      onCta: () {
        unawaited(_save());
      },
      child: _IdentityBody(
        nameController: _name,
        handleController: _handle,
        check: _check,
        onNameChanged: _onNameChanged,
        onHandleChanged: _onHandleChanged,
      ),
    );
  }
}
