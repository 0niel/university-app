# General
- Framework: Flutter (Dart). State management: BLoC/Cubit (`flutter_bloc`). Routing: `go_router`. Codegen: `build_runner`, `freezed`, `json_serializable`.
- Imports must be absolute (e.g., `package:rtu_mirea_app/...`); avoid relative `../` chains.
- Prefer feature-first layout: `lib/<feature>/{bloc,view,widgets,models}`; keep shared UI in `packages/app_ui` (see theming rules).
- Keep UI lean: move logic to blocs/cubits; keep events/states in their own files or `freezed` parts.
- No useless comments; keep code self-explanatory.
- Tooling: use `flutter pub`/`dart run` for Dart; for any JS tasks use `pnpm` (per project rule).
