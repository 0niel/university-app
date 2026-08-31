/// Stac (BDUI) runtime bridge for mini apps: app_ui widget parsers,
/// custom deep-link/host actions and the secure proxy network layer.
library;

export 'package:stac/stac.dart' show Stac;

export 'src/actions/storage_actions.dart'
    show clearMiniAppStorage, kStoragePlaceholderPrefix, primeMiniAppStorage;
export 'src/expression/expression_engine.dart'
    show
        ExpressionAnalysis,
        ExpressionsEngine,
        MiniAppExpressionEngine,
        defaultMiniAppExpressionEngine;
export 'src/expression/template_resolver.dart' show resolveTemplate;
export 'src/expression/tree_resolver.dart'
    show MiniAppTreeResolver, wrapScreenForLogic;
export 'src/mini_app_host.dart';
export 'src/stac_bridge.dart';
