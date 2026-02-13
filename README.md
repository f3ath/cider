![logo]

# Cider (CI for Dart: Efficient Release)

Cider is a CLI tool for Dart package maintenance. It updates `CHANGELOG.md` and `pubspec.yaml` to help automate releases.

## Assumptions

Cider expects:

- a `CHANGELOG.md` file in the project root
- changelog format compatible with [Keep a Changelog][Changelog]
- simple Markdown in changelog entries (no HTML or complex formatting)
- project versions that follow [Semantic Versioning 2.0.0][semver]

## Installation

```bash
dart pub global activate cider
```

## Configuration

Configure Cider in `pubspec.yaml` under `cider`:

```yaml
cider:
  link_template:
    tag: https://github.com/example/project/releases/tag/%tag%
    diff: https://github.com/example/project/compare/%from%...%to%
    version: v%version% # default: %version%
```

Placeholders:

- `%from%` - previous version tag
- `%to%` - current version tag
- `%tag%` - release tag

## Project root detection

You can run Cider from any subdirectory. It searches upward for `pubspec.yaml`.

To override auto-detection:

```bash
cider --project-root=/path/to/project version
```

## Changelog commands

These commands modify `CHANGELOG.md` unless stated otherwise.

### Add an entry

```bash
cider log <type> <description>
```

- `<type>`: `added`, `changed`, `deprecated`, `removed`, `fixed`, `security`
- `<description>`: one Markdown line

Examples:

```bash
cider log changed 'Improve parser performance'
cider log added 'Support workspace mode'
cider log fixed 'Null pointer in changelog parser'
```

### Release `Unreleased` entries

```bash
cider release [options]
```

Options:

- `--date` - release date (default: today)

If `link_template.diff` is configured, Cider generates changelog diff links automatically.

### Print changes for a version (read-only)

```bash
cider describe [<version>] [options]
```

- `<version>` defaults to `Unreleased` if omitted

Options:

- `--only-body` - omit section header and link footer

### List versions

```bash
cider list [options]
```

Options:

- `--include-yanked`, `-y`
- `--include-unreleased`, `-u`

## Version commands

These commands operate on `version` in `pubspec.yaml`.

### Print current version (read-only)

```bash
cider version
```

### Set version

```bash
cider version <new_version>
```

`<new_version>` must be [SemVer][semver]-compatible.

Examples:

| Before   | Command                           | After          |
|----------|-----------------------------------|----------------|
| 1.2.3+1  | `cider version 3.2.1`             | 3.2.1          |
| 0.2.1-dev| `cider version 0.0.1-alpha+42`    | 0.0.1-alpha+42 |

### Yank / unyank a release in changelog

```bash
cider yank <version>
cider unyank <version>
```

Yanked versions are marked as `[YANKED]` in `CHANGELOG.md`.

### Bump version

```bash
cider bump <part> [options]
```

`<part>` can be:

- `breaking` (`y` for `0.y.z`, otherwise `x` for `x.y.z`)
- `major`
- `minor`
- `patch`
- `build`
- `pre` (pre-release)
- `release` (remove pre-release suffix)

Options:

- `--keep-build` - keep existing build metadata
- `--bump-build` - increment build metadata
- `--build=<value>` - set build metadata explicitly
- `--pre=<prefix>` - set pre-release prefix

Notes:

- For `pre` and `build`, Cider increments the rightmost dot-separated numeric identifier.
- If no numeric identifier exists, Cider appends `.1`.
- Per SemVer, build metadata does not affect version precedence.

Examples:

| Before           | Command                                     | After            |
|------------------|---------------------------------------------|------------------|
| 1.2.1-alpha+42   | `cider bump breaking`                       | 2.0.0            |
| 0.2.1-alpha+42   | `cider bump breaking`                       | 0.3.0            |
| 0.2.1-alpha+42   | `cider bump major`                          | 1.0.0            |
| 0.2.1-alpha+42   | `cider bump minor`                          | 0.3.0            |
| 0.2.1-alpha+42   | `cider bump patch`                          | 0.2.1            |
| 0.2.1            | `cider bump patch`                          | 0.2.2            |
| 0.2.1-alpha+42   | `cider bump pre`                            | 0.2.1-alpha.1    |
| 1.2.1-alpha+42   | `cider bump breaking --keep-build`          | 2.0.0+42         |
| 0.2.1-alpha+42   | `cider bump breaking --bump-build`          | 0.3.0+43         |
| 0.2.1-alpha+42   | `cider bump major --build=2020-02-02`       | 1.0.0+2020-02-02 |
| 0.2.1-alpha+42   | `cider bump minor --pre=alpha --bump-build` | 0.3.0-alpha+43   |
| 0.2.1-alpha+42   | `cider bump release`                        | 0.2.1            |
| 0.2.1-alpha+42   | `cider bump release --keep-build`           | 0.2.1+42         |

## Exit codes

| Code | Meaning |
|------|---------|
| 0    | Success |
| 64   | Usage error (invalid arguments) |
| 65   | Data error (missing/invalid project files) |
| 70   | Internal software error (consider opening an issue) |

[logo]: https://raw.githubusercontent.com/f3ath/cider/master/cider.png
[semver]: https://semver.org
[Changelog]: https://keepachangelog.com/en/1.1.0/
