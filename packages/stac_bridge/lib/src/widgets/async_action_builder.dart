import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/actions/action_execution.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class AsyncActionBuilder extends StatefulWidget {
  const AsyncActionBuilder({
    required this.action,
    required this.builder,
    this.enabled = true,
    this.loading = false,
    super.key,
  });

  final Object? action;
  final bool enabled;
  final bool loading;
  final Widget Function(BuildContext, VoidCallback?, {required bool loading})
  builder;

  @override
  State<AsyncActionBuilder> createState() => _AsyncActionBuilderState();
}

class _AsyncActionBuilderState extends State<AsyncActionBuilder> {
  bool _running = false;

  Future<void> _run() async {
    if (_running || widget.loading || !widget.enabled) return;
    setState(() => _running = true);
    try {
      await runMiniAppAction(context, widget.action);
    } on Exception {
      if (mounted) {
        ToastManager.showError(
          context,
          message: kitText(
            context,
            ru: 'Не удалось выполнить действие. Попробуйте ещё раз.',
            en: 'Could not complete the action. Please try again.',
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = _running || widget.loading;
    return widget.builder(
      context,
      widget.enabled && !busy && widget.action is Map<Object?, Object?>
          ? _run
          : null,
      loading: busy,
    );
  }
}
