import 'package:flutter/widgets.dart';
import 'package:neon_framework/src/models/disposable.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// A [Provider] that manages the lifecycle of a [Disposable] value it provides
/// by delegating [Create] and calling [Disposable.dispose].
class NeonProvider<T extends Disposable> extends SingleChildStatelessWidget {
  /// Creates a value, stores it, and exposes it to its descendants.
  const NeonProvider({
    required Create<T> create,
    super.key,
    this.child,
    this.lazy = true,
  })  : _create = create,
        _value = null,
        super(child: child);

  /// Expose an existing value without disposing it.
  ///
  /// {@macro provider.updateshouldnotify}
  const NeonProvider.value({
    required T value,
    super.key,
    this.child,
  })  : _value = value,
        _create = null,
        lazy = true,
        super(child: child);

  /// Optional widget below this widget in the tree having access to the value.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// Whether the value should be created lazily.
  /// Defaults to `true`.
  final bool lazy;

  final Create<T>? _create;

  final T? _value;

  /// Method that allows widgets to access the value as long as their
  /// `BuildContext` contains a [NeonProvider] or [Provider] instance of the
  /// specified type.
  ///
  /// Calling this method is equivalent to calling:
  ///
  /// ```dart
  /// Provider.of(context, listen: false);
  /// ```
  ///
  /// If we want to access an instance of `DisposableA` which was provided higher up
  /// in the widget tree we can do so via:
  ///
  /// ```dart
  /// NeonProvider.of<DisposableA>(context);
  /// ```
  static T of<T>(
    BuildContext context, {
    bool listen = false,
  }) {
    try {
      return Provider.of<T>(context, listen: listen);
    } on ProviderNotFoundException catch (e) {
      if (e.valueType != T) {
        rethrow;
      }
      throw FlutterError(
        '''
        NeonProvider.of() called with a context that does not contain a $T.
        No ancestor could be found starting from the context that was passed to NeonProvider.of<$T>().

        This can happen if the context you used comes from a widget above the NeonProvider.

        The context used was: $context
        ''',
      );
    }
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(
      child != null,
      '$runtimeType used outside of MultiBlocProvider must specify a child',
    );
    final value = _value;
    return value != null
        ? InheritedProvider<T>.value(
            value: value,
            lazy: lazy,
            child: child,
          )
        : InheritedProvider<T>(
            create: _create,
            dispose: (_, value) => value.dispose(),
            lazy: lazy,
            child: child,
          );
  }
}
