# Swift Helpers Changelog

## 3.0.0 (2025-10-15)

- Updated package name in the manifest to `SwiftHelpers`.
- Split package into modules.
- Heavily reworked URL extensions based on RFC 3986, including normalization, relativization, relationships, base URL, addition of reference kind, and other changes. Added `FilenameComponents` and `HierarchicalPath` structures.
- Reworked and expanded atomic property wrappers.
- Added:
	- `CharacterSet` extensions.
	- `Data` extensions.
- Updated:
	- Logging extensions.
	- `KeyValuePairs` formatter refactored.
	- `Stopwatch` and `SplitStopwatch` changed to use measurement, added formatting.
- Adopted Swift 6 language mode.
- Other changes and improvements.

## 2.2.0 (2024-04-05)

- Added `URL.expandingTildeInPath`.

## 2.1.1 (2024-04-04)

- Added availability condition.

## 2.1.0 (2024-04-03)

- Added:
	- `EventMonitor` wrapper.
	- `Timer` extension.

## 2.0.0 (2024-03-26)

- Updated package name in the manifest to `swift-helpers`.
- Reorganization of helpers.
- Added availability conditions.
- Refactored:
	- `URL` extensions.
	- `URLBookmark` adds compatibility with SwiftData.

## 1.0.0 (2023-12-20)

- Initial release.
