import 'package:flutter/widgets.dart';

/// The signature of a function generating a label.
///
/// The `context` includes the [WidgetsApp]'s [Localizations] widget so that
/// this method can be used to produce a localized label.
typedef LabelBuilder = String Function(BuildContext);
