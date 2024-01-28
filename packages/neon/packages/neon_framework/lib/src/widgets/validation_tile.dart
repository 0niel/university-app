import 'package:flutter/material.dart';
import 'package:neon_framework/src/widgets/adaptive_widgets/list_tile.dart';

/// Validation list tile.
///
/// A [ListTile] used to display the progress of a validation.
///
/// See:
///   * [ValidationState] for the possible states
class NeonValidationTile extends StatelessWidget {
  /// Creates a new validation list tile.
  const NeonValidationTile({
    required this.title,
    required this.state,
    super.key,
  });

  /// The title of this tile.
  final String title;

  /// The state to display.
  final ValidationState state;

  @override
  Widget build(BuildContext context) {
    const size = 32.0;

    final leading = switch (state) {
      ValidationState.loading => const SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        ),
      ValidationState.failure => Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.error,
          size: size,
        ),
      ValidationState.canceled => Icon(
          Icons.cancel_outlined,
          color: Theme.of(context).disabledColor,
          size: size,
        ),
      ValidationState.success => Icon(
          Icons.check_circle,
          color: Theme.of(context).colorScheme.primary,
          size: size,
        ),
    };
    return AdaptiveListTile(
      leading: leading,
      title: Text(
        title,
        style: state == ValidationState.canceled ? TextStyle(color: Theme.of(context).disabledColor) : null,
      ),
    );
  }
}

/// Validation states for [NeonValidationTile].
enum ValidationState {
  /// Indicates a loading state.
  loading,

  /// Indicates an error.
  failure,

  /// Indicates the process has been canceled.
  canceled,

  /// Indicates a success state.
  success,
}
