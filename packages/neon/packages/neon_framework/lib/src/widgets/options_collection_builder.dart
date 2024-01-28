import 'package:flutter/material.dart';
import 'package:neon_framework/src/settings/models/options_collection.dart';

/// A widget that rebuilds when one of the options in an [OptionsCollection] changes.
class OptionsCollectionBuilder<T extends OptionsCollection> extends StatefulWidget {
  /// Creates a [OptionsCollectionBuilder].
  ///
  /// The [valueListenable] and [builder] arguments must not be null.
  /// The [child] is optional but is good practice to use if part of the widget
  /// subtree does not depend on the value of the [valueListenable].
  const OptionsCollectionBuilder({
    required this.valueListenable,
    required this.builder,
    this.child,
    super.key,
  });

  /// The [OptionsCollection] whose values you depend on in order to build.
  final T valueListenable;

  /// A [ValueWidgetBuilder] which builds a widget depending on the
  /// [valueListenable]'s value.
  ///
  /// Can incorporate a [valueListenable] value-independent widget subtree
  /// from the [child] parameter into the returned widget tree.
  ///
  /// Must not be null.
  final ValueWidgetBuilder<T> builder;

  /// A [valueListenable]-independent widget which is passed back to the [builder].
  ///
  /// This argument is optional and can be null if the entire widget subtree the
  /// [builder] builds depends on the value of the [valueListenable]. For
  /// example, in the case where the [valueListenable] is a [String] and the
  /// [builder] returns a [Text] widget with the current [String] value, there
  /// would be no useful [child].
  final Widget? child;

  @override
  State<StatefulWidget> createState() => _OptionsCollectionBuilderState<T>();
}

class _OptionsCollectionBuilderState<T extends OptionsCollection> extends State<OptionsCollectionBuilder<T>> {
  @override
  void initState() {
    super.initState();
    widget.valueListenable.listenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(OptionsCollectionBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.valueListenable != widget.valueListenable) {
      oldWidget.valueListenable.listenable.removeListener(_valueChanged);
      widget.valueListenable.listenable.addListener(_valueChanged);
    }
  }

  @override
  void dispose() {
    widget.valueListenable.listenable.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, widget.valueListenable, widget.child);
}
