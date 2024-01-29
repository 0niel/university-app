import 'package:flutter/material.dart';
import 'package:neon_framework/src/theme/neon.dart';

/// Custom app branding
///
/// Descendant widgets obtain the current [Branding] object using
/// `Branding.of(context)`. Instances of [Branding] can be customized with
/// [Branding.copyWith].
@immutable
class Branding {
  /// Creates a custom branding
  const Branding({
    required this.name,
    required this.logo,
    this.sourceCodeURL,
    this.issueTrackerURL,
    this.legalese,
    this.showLoginWithNextcloud = true,
  });

  /// App name
  final String name;

  /// Logo of the app shown on various places in the app.
  final Widget logo;

  /// The URL where the source code can be seen
  final String? sourceCodeURL;

  /// The URL where users can report bugs and request features
  final String? issueTrackerURL;

  /// A string to show in small print.
  ///
  /// Typically this is a copyright notice shown as the [AboutDialog.applicationLegalese].
  final String? legalese;

  /// Whether to show the Nextcloud logo on the LoginPage
  final bool showLoginWithNextcloud;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  Branding copyWith({
    String? name,
    Widget? logo,
    String? legalese,
  }) =>
      Branding(
        name: name ?? this.name,
        logo: logo ?? this.logo,
        legalese: legalese ?? this.legalese,
      );

  /// The data from the closest [Branding] instance given the build context.
  static Branding of(BuildContext context) => Theme.of(context).extension<NeonTheme>()!.branding;

  @override
  int get hashCode => Object.hashAll([
        name,
        logo,
        legalese,
      ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Branding && name == other.name && logo == other.logo && legalese == other.legalese;
  }
}
