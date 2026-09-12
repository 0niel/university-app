# University modules

The default application has no optional provider implementation. Its
`university_provider` path dependency returns an empty module list. The host
depends on the `university_modules` contract package and does not import an
institution implementation.

An institution integration is a separate repository whose root package is named
`university_provider`. It exports `createUniversityModules()` from
`lib/university_provider.dart` and depends on `university_modules: ^0.1.0`.
The repository may stay private: contributors without access build the default
application, while releases and developers with access build the integration.

## Selecting a provider

`config/university_provider.json` pins the institution integration to a GitHub
repository and an immutable commit:

```json
{
  "repository": "owner/integration",
  "ref": "<full commit SHA>",
  "path": "."
}
```

Developers with read access attach it with one command. The tool probes the
repository; when it is unreachable, the default provider stays selected and
the command still succeeds:

```powershell
fvm dart run tool/configure_university_provider.dart --pinned
fvm flutter pub get --no-example
```

To work on the integration itself, point the tool at a local checkout:

```powershell
fvm dart run tool/configure_university_provider.dart --local ../integration
fvm flutter pub get --no-example
```

Any other immutable Git revision can be selected with
`--repository <https-url> --ref <full-commit-sha>` and optional `--path`.
Mutable branches and credential-bearing URLs are rejected. `--remove` restores
the default provider.

The tool writes the ignored `pubspec_overrides.yaml`, preserves existing
dependency pins and saves previous overrides under `.dart_tool`. Resolving
dependencies with a provider selected rewrites `pubspec.lock` locally; the
committed lock must keep the default provider, which
`test/tool/university_provider_lock_test.dart` enforces whenever no override is
active. The default provider intentionally lives outside the Dart workspace;
the contract package belongs to the workspace.

## Releases and patches

Release workflows check the pinned repository out into the ignored
`private/university_provider` directory with the `UNIVERSITY_PROVIDER_DEPLOY_KEY`
secret, select it with the tool and resolve dependencies before building. The
release manifest records the provider commit as `provider_sha` and the resolved
`pubspec.lock` digest, and the lock is published next to the manifest.

Shorebird patches resolve the registered release, check the same provider
commit out, restore the registered lock and resolve it with
`--enforce-lockfile`, so a patch contains exactly the provider code of its
release. Releases without a recorded provider keep the default provider.
Codemagic builds fetch the pinned commit with the same deploy key from its
`university` variable group.

Update the pin by editing `config/university_provider.json` with the new full
commit SHA. The private checkout, the deploy key and the override file are never
committed; `tool/verify_private_native_boundary.dart` checks the boundary.

## Host contract

`ModuleDescriptor` declares a unique lowercase slug, display title and
description, supported organization IDs and host API version. API version 1 is
supported. The registry rejects invalid or duplicate identifiers and hides
modules for other organizations or incompatible API versions. Each available
module appears in Services and opens through `/services/modules/<id>`.
The optional `localize` callback supplies the title and description for the
application language without changing the module identifier.

`UniversityModule.build(ModuleHost host)` creates the native interface. The
implementation uses the shared `app_ui` package, handles its own connection
screen and connects to its service only after the user chooses to do so.
Registration and widget construction must not initiate interactive login.

The SDK declares contracts only. The host adapter owns account checks, scoped
storage and navigation; provider repositories and Cubits stay inside the
optional package.

The host supplies the current organization and signed-in application account.
Its secure-storage methods are isolated by organization, application account
and module. Storage keys allow letters, digits, dots, underscores and hyphens,
up to 120 characters. Authentication cookies, tokens and private cached data
belong in this storage, never in preferences or module descriptors.

Account changes replace the module widget. Old host storage and digital-pass
operations fail after the account changes or the module closes. The module
must cancel requests and close owned repositories and subscriptions when its widget is
disposed, and must discard responses from a previous upstream session after
disconnecting or changing accounts. The module owns explicit connection,
reconnection and removal of its scoped stored session.

On Android, an enabled digital-pass integration exposes `openDigitalPass` and
optional `setDigitalPassSession` and `clearDigitalPassSession` callbacks.
The first callback transfers an existing
institution session to the host's pass repository. It does not send a
verification code, bind a device or remove a bound pass. Modules must check
`digitalPassAvailable`; other module features remain available when card
emulation is unsupported.

On module disconnect, invoke `clearDigitalPassSession` while the module is
still active. The host restores the shared session at startup when its secure
owner matches the university and application account. Application logout and
account transitions clear it. These operations retain the device's bound pass
and its native emulation setting. Legacy sessions without an owner are cleared
once during migration; subsequent updates preserve sessions for the same owner.
The pass repository delegates secure-storage operations to a serialized store,
including owner changes and rollback of interrupted native-pass writes.

The optional `DigitalPassDeviceHost` capability clears a bound pass from the
current device. Use it only after the user explicitly requests removal and the
institution confirms unlinking. Session disconnection must not invoke it.
If local cleanup fails after server confirmation, retry the local cleanup
without repeating the upstream unlink request.

## Delivery boundaries

Provider selection happens at build time. An application built with the default
provider excludes the institution package from its dependency graph. A build
containing a provider still lets each user choose whether to connect its
account. This connection is not a downloadable executable module. Any runtime
configuration or remote catalog contains data only; native implementation
updates require a new application build.

Map browsing and other shared application features remain independent of the
institution provider. Existing pass routes remain compatible with shortcuts
and deep links.
