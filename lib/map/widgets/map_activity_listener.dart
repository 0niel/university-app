import 'package:flutter/widgets.dart';

class MapActivityListener extends StatefulWidget {
  const MapActivityListener({
    required this.onChanged,
    required this.child,
    super.key,
  });

  final ValueChanged<bool> onChanged;
  final Widget child;

  @override
  State<MapActivityListener> createState() => _MapActivityListenerState();
}

class _MapActivityListenerState extends State<MapActivityListener>
    with WidgetsBindingObserver {
  bool _active = false;
  bool? _reported;
  bool _pending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncActivity();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    setState(_syncActivity);
    _reportActivity();
  }

  void _syncActivity() {
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    _active =
        TickerMode.valuesOf(context).enabled &&
        (ModalRoute.isCurrentOf(context) ?? true) &&
        (lifecycle == null || lifecycle == AppLifecycleState.resumed);
    if (_pending) return;
    _pending = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pending = false;
      _reportActivity();
    });
  }

  void _reportActivity() {
    if (!mounted || _reported == _active) return;
    _reported = _active;
    widget.onChanged(_active);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TickerMode(
    enabled: _active,
    child: widget.child,
  );
}
