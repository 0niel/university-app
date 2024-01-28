# Contributing

## Setup
This project uses an assortment of tools for the development.
Currently included are:
- [fvm](https://pub.dev/packages/fvm) for managing Flutter versions
- [melos](https://pub.dev/packages/melos) for managing packages in this monorepo
- [husky](https://pub.dev/packages/husky) for managing git hooks
- [commitlint_cli](https://pub.dev/packages/commitlint_cli) for validating commits according to the conventional commits specification

To set up all these tools run the `./tool/setup.sh` script.
Note that you need to have Dart installed and [`~/.pub-cache/bin/` needs to be in your PATH](https://dart.dev/tools/pub/cmd/pub-global#running-a-script-from-your-path) before running the script.

You will need to have the following dependencies installed to get the app running:
- [yq](https://github.com/kislyuk/yq)
- [sqlite3](https://pub.dev/packages/sqflite_common_ffi#getting-started)

For working with lower levels like generating the OpenAPI specifications a few more dependencies are required:
- [jsonpatch](https://pypi.org/project/jsonpatch)
- [PHP](https://www.php.net)
- [composer](https://getcomposer.org)

## Picking an issue
You may wish to start with our list of [good first issues](https://github.com/nextcloud/neon/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22)

## Commits
All commits need to be signed and signed off to to be pass our tests.
To sign off your commits use `git commit --signoff`.
To setup commit signing please consult the [Github documentation](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits).
We use conventional commits to have meaningful commit messages and be able to generate changelogs.
A non-breaking feature contribution to `neon_notes` could look like this:
```bash
git commit -m "feat(neon_notes): Add a super cool feature."
```
You can read the full documentation at https://www.conventionalcommits.org.

## Tools
We maintain a collection of scripts in `./tool/`.
They range from setting up a local Nextcloud server (`./tool/dev.sh`) to generating assets.

## Monorepo
For easier development we use a monorepo structure.
This means that we have multiple packages in one git repository.
We use [melos](https://pub.dev/packages/melos) to manage the packages in this repository.

Take a look at our [melos.yaml](melos.yaml) to find useful commands for running commands like build_runner or the analyzer in all packages.

## Linting
We use very strict static code analysis (also known as linting) rules.
This enables us to maintain and verify a consistent code style throughout the repository.
Please make sure your code passes linting.

You can read more about it on [dart.dev](https://dart.dev/tools/linter-rules).

## Testing
If you found a bug and are here to fix it, please make sure to also submit a test that validates that the bug is fixed.
This way we can make sure it will not be introduced again.

## Documentation
Whenever you are submitting new features make sure to also add documentation comments in the code.
Please adhere to the [effective-dart](https://dart.dev/effective-dart/documentation) documentation guidelines.

## Workflow
We use a rebase workflow, meaning that we rebase PRs onto the latest main branch instead of merging the current main into the development branches.
This helps to keep the git history cleaner and easier to bisect in the case of debugging an error.
You can read more on it [here](https://www.atlassian.com/git/tutorials/merging-vs-rebasing).
