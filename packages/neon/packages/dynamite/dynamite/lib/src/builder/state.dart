import 'package:code_builder/code_builder.dart';
import 'package:dynamite/src/models/dynamite_config/config.dart';
import 'package:dynamite/src/models/type_result.dart';

class State {
  State(this.buildConfig);

  final DynamiteConfig buildConfig;

  final output = <Spec>[];
  final resolvedTypes = <TypeResult>{};
  final resolvedInterfaces = <TypeResult>{};
  final emitter = DartEmitter.scoped(
    orderDirectives: true,
    useNullSafetySyntax: true,
  );

  Iterable<TypeResultSomeOf> get uniqueSomeOfTypes {
    final someOfs = resolvedTypes.whereType<TypeResultSomeOf>();
    final uniqueTypes = <String, TypeResultSomeOf>{};

    for (final result in someOfs) {
      uniqueTypes[result.typeName] = result;
    }

    return uniqueTypes.values;
  }

  /// Wether the state contains resolved types that need the built_value generator.
  bool get hasResolvedBuiltTypes => resolvedTypes
      .where(
        (type) => type is TypeResultEnum || type is TypeResultObject && type.className != 'ContentString',
      )
      .isNotEmpty;
}
