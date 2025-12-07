# General
- Framework: Flutter (Dart). State management: BLoC/Cubit (`flutter_bloc`). Routing: `go_router`. Codegen: `build_runner`, `freezed`, `json_serializable`.
- Imports must be absolute (e.g., `package:rtu_mirea_app/...`); avoid relative `../` chains.
- Prefer feature-first layout: `lib/<feature>/{bloc,view,widgets,models}`; keep shared UI in `packages/app_ui` (see theming rules).
- Keep UI lean: move logic to blocs/cubits; keep events/states in their own files or `freezed` parts.
- No useless comments; keep code self-explanatory.
- Tooling:
  - Flutter via FVM (`fvm flutter ...`) to respect the pinned SDK.
  - Workspace orchestration via Melos (see `melos.yaml`); use `melos bs` / `melos run ...` as defined.
  - For Dart scripts: `flutter pub`/`dart run` (through FVM).

# Dart General Guidelines

## Basic Principles
- Use English for all code and documentation.
- Always declare the type of each variable and function (parameters and return value).
  - Avoid using `dynamic`/`any`.
  - Create necessary types.
- Don't leave blank lines within a function.
- One export per file.

## Nomenclature
- Use `PascalCase` for classes.
- Use `camelCase` for variables, functions, and methods.
- Use `snake_case` for file and directory names.
- Use `UPPERCASE` for environment variables.
  - Avoid magic numbers and define constants.
- Start each function with a verb.
- Use verbs for boolean variables. Example: `isLoading`, `hasError`, `canDelete`, etc.
- Use complete words instead of abbreviations and correct spelling.
  - Except for standard abbreviations like API, URL, etc.
  - Except for well-known abbreviations:
    - `i`, `j` for loops
    - `err` for errors
    - `ctx` for contexts

## Functions
- Write short functions with a single purpose. Less than 20 instructions.
- Name functions with a verb and something else.
  - If it returns a boolean, use `isX` or `hasX`, `canX`, etc.
  - If it doesn't return anything, use `executeX` or `saveX`, etc.
- Avoid nesting blocks by:
  - Early checks and returns.
  - Extraction to utility functions.
- Use higher-order functions (`map`, `filter`, `reduce`, etc.) to avoid function nesting.
  - Use arrow functions for simple functions (less than 3 instructions).
  - Use named functions for non-simple functions.
- Use default parameter values instead of checking for null.
- Reduce function parameters using RO-RO (Request Object - Response Object):
  - Use an object to pass multiple parameters.
  - Use an object to return results.
  - Declare necessary types for input arguments and output.
- Use a single level of abstraction.

## Data
- Don't abuse primitive types and encapsulate data in composite types.
- Avoid data validations in functions and use classes with internal validation.
- Prefer immutability for data.
  - Use `final`/`const` for data that doesn't change.

## Classes
- Follow SOLID principles.
- Prefer composition over inheritance.
- Declare interfaces (abstract classes) to define contracts.
- Write small classes with a single purpose.
  - Less than 200 instructions.
  - Less than 10 public methods.
  - Less than 10 properties.

## Exceptions
- Use exceptions to handle errors you don't expect.
- If you catch an exception, it should be to:
  - Fix an expected problem.
  - Add context.
  - Otherwise, use a global handler.

## Testing
- Follow the Arrange-Act-Assert convention for tests.
- Name test variables clearly (e.g., `inputX`, `mockX`, `actualX`, `expectedX`).
- Write unit tests for each public function.
  - Use test doubles to simulate dependencies (except for inexpensive third-party ones).
- Write acceptance tests for each module.
  - Follow the Given-When-Then convention.

# Specific to Flutter

## Basic Principles
- Use Clean Architecture:
  - Organize code into `repositories`, `entities`, `services` where needed.
- Use **Repository Pattern** for data persistence.
- Use **BLoC/Cubit** for business logic and state management.
- Use **freezed** to manage UI states.
- Use `yx_scope` (DI) to manage dependencies:
  - Register singletons for services/repositories.
- Use `go_router` to manage routes.
  - Use extras to pass data between pages.
- Use `ThemeData` to manage themes.
- Use `AppLocalizations` to manage translations.
- Use constants to manage constant values.
- **Avoid Nesting Widgets Deeply**:
  - Deep nesting impacts readability, maintainability, and performance.
  - Break down complex widget trees into smaller, reusable, focused components.
  - A flatter structure improves build efficiency and state management.
- Utilize `const` constructors wherever possible to reduce rebuilds.

## Testing
- Use standard widget testing for Flutter.
- Use integration tests for API modules.
