import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

part 'config.g.dart';

/// The configuration used by the dynamite builder.
abstract class DynamiteConfig implements Built<DynamiteConfig, DynamiteConfigBuilder> {
  factory DynamiteConfig([void Function(DynamiteConfigBuilder) updates]) = _$DynamiteConfig;

  const DynamiteConfig._();

  /// Constructs the dynamite config from a json like map.
  factory DynamiteConfig.fromJson(Map<String, dynamic> json) => _serializers.deserializeWith(serializer, json)!;

  /// Serializes this configuration to json.
  Map<String, dynamic> toJson() => _serializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  static Serializer<DynamiteConfig> get serializer => _$dynamiteConfigSerializer;

  static const String configPath = 'dynamite.yaml';

  /// A set of lint rules to ignore for the entire generated file.
  @BuiltValueField(wireName: 'analyzer_ignores')
  BuiltSet<String>? get analyzerIgnores;

  /// A set of regular expressions used to exclude parts from code coverage.
  ///
  /// All matches will be wrapped in `// coverage:ignore-start` and `// coverage:ignore-end` blocks.
  @BuiltValueField(wireName: 'coverage_ignores')
  BuiltSet<String>? get coverageIgnores;

  /// The specified line with the formatter should use.
  int? get pageWidth;

  /// A collection of dynamite configs for a specific file.
  ///
  /// This parameter is only supported for the top level config.
  // overrides is reserved in the build.yaml
  BuiltMap<String, DynamiteConfig>? get overrides;

  /// Whether the generated library should be marked with the `@experimental` annotation.
  bool get experimental;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DynamiteConfigBuilder b) {
    b.experimental ??= false;
  }

  /// Gets the config for the given [uri].
  ///
  /// Returns this if no override is set.
  DynamiteConfig configFor(String uri) {
    if (overrides == null) {
      return this;
    }

    DynamiteConfig? override;
    for (final entry in overrides!.entries) {
      if (entry.key == uri) {
        override = entry.value;
        break;
      }
    }

    if (override == null) {
      return this;
    }

    return merge(override);
  }

  /// Merges `this` config with the given [override].
  ///
  /// Throws a [ArgumentError] if the override has overrides itself.
  DynamiteConfig merge(DynamiteConfig other) {
    if (other.overrides != null) {
      throw ArgumentError('Configs can only be merged with a config that does not have further overrides');
    }

    return rebuild((b) {
      final analyzerIgnores = other.analyzerIgnores;
      if (analyzerIgnores != null) {
        b.analyzerIgnores.replace(analyzerIgnores);
      }

      final coverageIgnores = other.coverageIgnores;
      if (coverageIgnores != null) {
        b.coverageIgnores.replace(coverageIgnores);
      }

      b.experimental = other.experimental;
    });
  }
}

@SerializersFor([
  DynamiteConfig,
])
final Serializers _serializers = (_$_serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
