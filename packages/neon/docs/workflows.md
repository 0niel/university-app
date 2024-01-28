# Workflows

## Adding a new package to the Neon project

If you need to add a new package to the Neon project please make sure to execute all the following steps:
1. Use the according template by running `fvm dart create -t package package_name` or `fvm flutter create -t package package_name`.
2. Make sure to activate our strict linting by adding it to the package.
3. Regenerate the dependency overrides by executing `melos bootstrap`.
4. Add a Symlink to our main [license](../assets/AGPL-3.0.txt).
5. Update [commitlint.yaml](../commitlint.yaml) by adding the new package name.
6. Remove the package `.gitignore` (a global `.gitignore` for all packages is used instead).

## Publishing new versions of the packages

```bash
melos version --no-git-tag-version

# If necessary adjust the required dynamite_runtime version in dynamite and stage the changes

# Needed until https://github.com/invertase/melos/issues/591 is supported
git commit --amend --signoff --no-edit

# Create PR and get it merged

melos publish --git-tag-version
git push --follow-tags
```
