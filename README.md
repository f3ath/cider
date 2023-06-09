![logo]

# Cider (CI for Dart. Efficient Release)

A command-line utility to automate package maintenance. Manipulates the changelog and pubspec.yaml.

This tool assumes that the changelog:

- is called `CHANGELOG.md`
- is sitting in the project root folder
- strictly follows the [Changelog] format
- uses basic markdown (no HTML and complex formatting supported)

It also assumes that your project follows [Semantic Versioning v2.0.0](https://semver.org/spec/v2.0.0.html).

## Install

```
pub global activate cider
```

## Configure

Cider configuration is stored in `pubspec.yaml` under the key `cider`:

```yaml
cider:
  link_template:
    tag: https://github.com/example/project/releases/tag/%tag% # initial release link template
    diff: https://github.com/example/project/compare/%from%...%to% # subsequent releases link template
```

The `%from%`, `%to%`, and `%tag%` placeholders will be replaced with the corresponding version tags.

## Changelog

These commands manipulate `CHANGELOG.md`.

### Adding changes

Adds a new line to the `Unreleased` section of the changelog

```
cider log <type> <description>
```

- **type** is one of: `added`, `changed`, `deprecated`, `removed`, `fixed`, `security`
- **description** is a markdown text line

Examples:

```
cider log changed 'New turbo V6 engine installed'
cider log added 'Support for rocket fuel and kerosene'
cider log fixed 'Wheels falling off sporadically'
```

### Releasing the unreleased changes

Takes all changes from the `Unreleased` section on the changelog and creates a new release under the current version in
pubspec.yaml

```
cider release [options]
```

Options:

- `--date` to provide the release date (the default is today).

Cider will automatically generate the diff links in the changelog if the diff link template is found in the config.

### Printing the list of changes in the given version

Prints the corresponding section from `CHANGELOG.md` in markdown format. This command is read-only.

```
cider describe [<version>]
```

- **version** is an existing version from the changelog. If not specified, the `Unreleased` section will
  be used.

### Listing all versions in the changelog

Prints all versions from the changelog, highest to lowest.

```
cider list [options]
```

Options:
- `--include-yanked` or `-y` - includes yanked versions.
- `--include-unreleased` or `-u` - prints "Unreleased" in the top of the version list if there are unreleased changes.

## Version

These commands affect the `version` line in `pubspec.yaml`. If applied successfully, Cider will print the resulting
version.

### Printing the current project version

Prints the current version from `pubspec.yaml`. This command is read-only.

```
cider version
```

### Setting version to an arbitrary value

Sets the version in `pubspec.yaml` to the one provided. The new version must be [semver]-compatible.

```
cider version <new_version>
```

- **new_version** new value, must be [semver]-compatible

Examples:

| Version before | Command                        | Version after  |
|----------------|--------------------------------|----------------|
| 1.2.3+1        | `cider version 3.2.1`          | 3.2.1          |
| 0.2.1-dev      | `cider version 0.0.1-alpha+42` | 0.0.1-alpha+42 |

### Yanking/unyanking a version
The [Changelog] defines yanked releases as version that are pulled (withdrawn) due to a serious bug or security issue. 
According to the [Changelog], a yanked release should be marked with a `[YANKED]` tag in the changelog file.

To mark a version as yanked, run the following command:

```
cider yank <version>
```

To unyank a version, run the following command:

```
cider unyank <version>
```

### Bumping the project version

Bumps the corresponding part of the project version according to [semver].

```
cider bump <part> [options]
```

- **part** can be any of the following:
    - `breaking` (means `y` for `0.y.z` and `x` for `x.y.z`)
    - `major`
    - `minor`
    - `patch`
    - `build`
    - `pre` (pre-release)
    - `release` (promotes the version to a release, removing the pre-release part)

Options:

- `--keep-build` will retain the existing build part.
- `--bump-build` will increment the build part (see below).
- `--build=<value>` will set the build part to the given value. This is useful when build is a not a simple numeric
  value, e.g. a timestamp.
- `--pre=<prefix>` sets the prerelease prefix.

When bumping the `prerelease` or `build` parts, Cider will look for the rightmost dot-separated identifier. If the
identifier is an integer, it will be incremented stripping the leading zeroes. Otherwise, Cider will append `.1` to the
corresponding part.

Remember that according to [semver] v2, `build` is considered metadata and is ignored when determining version
precedence.

| Version before | Command                                     | Version after    |
|----------------|---------------------------------------------|------------------|
| 1.2.1-alpha+42 | `cider bump breaking`                       | 2.0.0            |
| 0.2.1-alpha+42 | `cider bump breaking`                       | 0.3.0            |
| 0.2.1-alpha+42 | `cider bump major`                          | 1.0.0            |
| 0.2.1-alpha+42 | `cider bump minor`                          | 0.3.0            |
| 0.2.1-alpha+42 | `cider bump patch`                          | 0.2.1            |
| 0.2.1          | `cider bump patch`                          | 0.2.2            |
| 0.2.1-alpha+42 | `cider bump pre`                            | 0.2.1-alpha.1    |
| 1.2.1-alpha+42 | `cider bump breaking --keep-build`          | 2.0.0+42         |
| 0.2.1-alpha+42 | `cider bump breaking --bump-build`          | 0.3.0+43         |
| 0.2.1-alpha+42 | `cider bump major --build=2020-02-02`       | 1.0.0+2020-02-02 |
| 0.2.1-alpha+42 | `cider bump minor --pre=alpha --bump-build` | 0.3.0-alpha+43   |
| 0.2.1-alpha+42 | `cider bump release`                        | 0.2.1            |
| 0.2.1-alpha+42 | `cider bump release --keep-build`           | 0.2.1+42         |

[logo]: https://raw.githubusercontent.com/f3ath/cider/master/cider.png
[semver]: https://semver.org
[Changelog]: https://keepachangelog.com/en/1.1.0/