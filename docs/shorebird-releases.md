# Shorebird release provenance

Native release workflows register their actual build automatically. Release versions
are workflow data, never an allowlist in the patch or promotion workflow.

Each `shorebird-{platform}-{version}` GitHub prerelease stores an attested
`release-manifest.json`. The manifest records the actual source commit and tree,
Shorebird identity and Flutter revision, build target, prepared configuration
digests, native module revision, and binary hashes. iOS also retains its resolved
`Podfile.lock`. Raw configuration, signing material, and private native code are
not published. Registry assets are write-once; conflicting replacements fail.

For an existing release without a manifest, run **Register Shorebird Release** on
the default branch with its successful original full-release run ID and platform.
The importer checks the immutable Actions archive digest, reads the version from
the APK or IPA, and matches it against Shorebird. Automatic Android imports also
require cryptographically verified APK provenance for the exact producer, source,
protected branch, GitHub-hosted runner, and run attempt. Both preparation and build
checkout logs must match that source, with successful master push CI completed
before the release started. A different build checkout, missing logs, or ambiguous
evidence prevents import. iOS historical imports require a manual full-release
run. Expired artifacts require recovery
of independently verifiable original evidence or a new native release.

Historical manifests explicitly list unavailable prepared inputs. An Android
native module revision comes from the original producer's pinned checkout.
Neither a historical import nor a matching Git diff proves compiled native
compatibility: Shorebird's native and asset checks remain mandatory.

To patch, pass an exact merged source SHA, platform, and registered version to
**Shorebird Staging Patch**. The source must have successful default-branch CI.
The verifier overlays Dart, localization, and test changes onto the original
release; build tools remain at the baseline. Changes to native code, assets,
dependencies, file modes, or unknown build inputs require a full release.

**Shorebird Patch Promotion** accepts the successful staging run and exact target.
It verifies the manifest, source tree, staging receipt, and live patch artifacts
before promoting to stable. Never bypass native or asset checks to force delivery
to an older installed build.
