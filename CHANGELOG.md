# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.10] - 2026-02-12
### Added
- Version tag template configuration (by [David Martos](https://github.com/davidmartos96))

## [0.2.9] - 2025-11-30
### Fixed
- Added missing export: cli/channel.dart

## [0.2.8] - 2024-06-09
### Changed
- Deps version bump and a minor refactor

## [0.2.7] - 2024-03-01
### Fixed
- The log command used to accept any prefix as an alias, this was broken in 0.2.6

## [0.2.6] - 2024-02-03
### Fixed
- Made `bump` and `log` proper subcommands to improve UX ([PR](https://github.com/f3ath/cider/pull/70) by [marvin-kolja](https://github.com/marvin-kolja))

## [0.2.5] - 2024-01-07
### Changed
- Bump dependencies

## [0.2.4] - 2023-10-10
### Changed
- Bumped dependencies

## [0.2.3] - 2023-06-15
### Fixed
- The `Diff` class had been erroneously put in `lib`. Moved back to `src/` where it belongs.

## [0.2.2] - 2023-06-11
### Added
- The `--only-body` option for the `describe` command.
- Support for the changelog section preamble, a free text right after the header.

## [0.2.1] - 2023-06-11
### Fixed
- "Error: No value found at /cider" when run with no configuration in pubspec.yaml

## [0.2.0] - 2023-06-10
### Added
- The `list` command to list all versions from the changelog.
- Restored the `--project-root` argument.

### Changed
- Bump min SDK version to 3.0.0.
- Exit codes to closer match POSIX.

## [0.1.6] - 2023-06-07
### Fixed
- Correctly abort upwards search for project root directory upon reaching filesystem root. (thanks [@maltevesper](https://github.com/maltevesper))

## [0.1.5] - 2023-03-30
### Added
- Ability to yank/unyank specific versions

## [0.1.4] - 2023-03-01
### Changed
- Bumped dependencies versions (thanks [@zeshuaro](https://github.com/zeshuaro))

## [0.1.3] - 2022-12-16
### Removed
- Dependency on intl (thanks [@zeshuaro](https://github.com/zeshuaro))

## [0.1.2] - 2022-12-07
### Added
- Release promotion command

## [0.1.1] - 2021-12-28
### Changed
- Updated dependencies

## [0.1.0] - 2021-05-12
### Added
- Sound null-safety.
- Support for pre-release version part.
- Ability to bump build together with other version parts.
- A plugin system to improve extensibility.

### Changed
- Configuration moved to pubspec.yaml.

## [0.0.5] - 2020-09-09
### Added
- Setting version explicitly
- Ability to retain pre-release part of the version

## [0.0.4] - 2020-08-10
### Changed
- Using a yaml manipulation library to updated pubspec.yaml. This expected to be more reliable than a regexp.

## [0.0.3] - 2020-08-09
### Changed
- Using a regex instead of yaml parser to modify pubspec.yaml. This should preserve existing file formatting

## [0.0.2+1] - 2020-07-29
### Fixed
- Fixed [\#1](https://github.com/f3ath/cider/issues/1) by downgrading the `path` dependency

## [0.0.2] - 2020-07-26
### Changed
- Updated the dependencies

## [0.0.1+2] - 2020-07-26
### Fixed
- Readme improvements

## [0.0.1+1] - 2020-07-26
### Fixed
- Code formatting to improve pub scores

## [0.0.1] - 2020-07-26
### Added
- Minor documentation improvements

### Fixed
- Usage exception does not print trace logs anymore

## [0.0.0+dev.2] - 2020-07-24
### Changed
- Updated dependencies

## 0.0.0+dev.1 - 2020-07-23
### Added
- Initial version

[0.2.10]: https://github.com/f3ath/cider/compare/0.2.9...0.2.10
[0.2.9]: https://github.com/f3ath/cider/compare/0.2.8...0.2.9
[0.2.8]: https://github.com/f3ath/cider/compare/0.2.7...0.2.8
[0.2.7]: https://github.com/f3ath/cider/compare/0.2.6...0.2.7
[0.2.6]: https://github.com/f3ath/cider/compare/0.2.5...0.2.6
[0.2.5]: https://github.com/f3ath/cider/compare/0.2.4...0.2.5
[0.2.4]: https://github.com/f3ath/cider/compare/0.2.3...0.2.4
[0.2.3]: https://github.com/f3ath/cider/compare/0.2.2...0.2.3
[0.2.2]: https://github.com/f3ath/cider/compare/0.2.1...0.2.2
[0.2.1]: https://github.com/f3ath/cider/compare/0.2.0...0.2.1
[0.2.0]: https://github.com/f3ath/cider/compare/0.1.6...0.2.0
[0.1.6]: https://github.com/f3ath/cider/compare/0.1.5...0.1.6
[0.1.5]: https://github.com/f3ath/cider/compare/0.1.4...0.1.5
[0.1.4]: https://github.com/f3ath/cider/compare/0.1.3...0.1.4
[0.1.3]: https://github.com/f3ath/cider/compare/0.1.2...0.1.3
[0.1.2]: https://github.com/f3ath/cider/compare/0.1.1...0.1.2
[0.1.1]: https://github.com/f3ath/cider/compare/0.1.0...0.1.1
[0.1.0]: https://github.com/f3ath/cider/compare/0.0.5...0.1.0
[0.0.5]: https://github.com/f3ath/cider/compare/0.0.4...0.0.5
[0.0.4]: https://github.com/f3ath/cider/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/f3ath/cider/compare/0.0.2+1...0.0.3
[0.0.2+1]: https://github.com/f3ath/cider/compare/0.0.2...0.0.2+1
[0.0.2]: https://github.com/f3ath/cider/compare/0.0.1+2...0.0.2
[0.0.1+2]: https://github.com/f3ath/cider/compare/0.0.1+1...0.0.1+2
[0.0.1+1]: https://github.com/f3ath/cider/compare/0.0.1...0.0.1+1
[0.0.1]: https://github.com/f3ath/cider/compare/0.0.0+dev.2...0.0.1
[0.0.0+dev.2]: https://github.com/f3ath/cider/compare/0.0.0+dev.1...0.0.0+dev.2
