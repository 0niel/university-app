# Dependencies

We follow the guidelines outlined in https://dart.dev/tools/pub/dependencies with some rules and automatic workflows:
1. We use the caret notation with the major version set to the latest major version and the minor and patch versions set to `0`. The constraint will be updated in case we need a particular feature or bug fix that was released in a newer version.
2. Dev dependencies should be pinned to the latest versions since they do not affect consumers of our packages.
3. Using Renovate we automatically update our dependency constraints. For non-dev dependencies this will be the latest major version, for everything else it will upgrade to the latest minor and patch versions as well. The lock files are also kept up-to-date with Renovate to compile everything with the latest available versions.
4. The same rules and automatic workflows apply to the Dart and Flutter versions we use.
5. The `app` package does not constrain the versions so the latest versions can be used. 
