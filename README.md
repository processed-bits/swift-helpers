# Swift Helpers

[![][shield-swift-versions]][spi-package]
[![][shield-platforms]][spi-package]

## Overview

The Swift Helpers package provides miscellaneous helpers, including extensions and custom types. The helpers are organized into modules listed below. See the [documentation](#documentation) or browse the source files for more information on usage or implementation details.

### AppKit Helpers

- Bindings: `NSKeyValueBindingCreation` informal protocol unbind helper.
- Controllers: `NSTreeController` properties for getting the topmost selection.
- Input: `EventMonitor` wrapper for `NSEvent`’s app monitoring methods.
- Menu: `NSMenuItem` convenience initializer, label item constructor.
- Touch bar: `NSTouchBar` items property, `AlertStyleGroupTouchBarItem` class.
- Views: `NSBrowser`, `NSImage`, `NSResponder`, `NSTableView`, `NSView` extensions, `ModalView` class.

### Core Animation Helpers

- `CALayer`, `CAMediaTiming` extensions.

### Core Data Helpers

- `NSManagedObjectContext`, `NSManagedObject` extensions.

### Core Graphics Helpers

- `CGFloat`, `CGSize` extensions.

### Debugging Helpers

- `dumpOutput(_:name:indent:maxDepth:maxItems:)` returning a dump as a string.
- `Stopwatch` and `SplitStopwatch` for measuring elapsed and lap times.
- `CallCounter` for counting the number or balance of calls.
- `ThreadCounter` for counting and listing concurrent code threads.
- `Thread` number getter.

### Exit Code Helpers

- `ExitCodeProtocol`, `ExitCodeProvidingError` protocols.
- `exit(_:)` overloads for terminating with exit codes.

### Foundation Helpers

- Collections: `IndexPath` node inspection methods.
- Data: creating and inspecting `Data` using set bit indices.
- Operations: `OperationQueue` and `BlockOperation` helpers.
- Processes: `Process` shell script initializer, `runUntilExit()` asynchronous wrapper. 
- Scheduling: `Timer` convenience constructor.
- Preferences: `UserDefault`, `UserDefaultRawRepresented`, and `UserDefaultJSONEncoded` property wrappers.
- Resources: `Bundle` information helpers.
- Strings and text: `CharacterSet` scalars getter.
- URLs and URIs:
	- `URLComponents` and `URL` helpers for normalizing URLs according to RFC 3986;
	- `URLComponents` and `URL` helpers for validating and deriving a base URL according to RFC 3986;
	- `URL` helpers for relativizing URLs, stem and filename components getters, and others;
	- `URL` conformance to `Comparable`;
	- `URIReferenceKind` enumeration;
	- `URLBookmark` structure;
	- `HierarchicalPath` structure for path components comparison, normalization, and manipulation;
	- `FilenameComponents` structure for containing directory, stem, and extension manipulation.
- URL loading system: `HTTPURLResponse` status helpers.

### Foundation Legacy Helpers

- Strings and text:
	- `NSRegularExpression` match operator, searching and replacing helpers;
	- `NSTextCheckingResult` range, capture group, and line number helpers;
	- `String` helpers for escaping `NSRegularExpression` pattern and template characters.

### Logging Helpers

- `ExtendedLogger` protocol and implementations for logging a location in source code.
- `LegacyLogger` structure resembling `Logger` for earlier versions of deployment targets.
- `String` `filePoint()` static method returning a string reference to a location in source code.

### Output

- `print(_:separator:terminator:to:)` overloads for writing into a file handle or the output stream of the given kind.
- `BufferedOutput` class for buffering output streams, accompanied by the `BufferedOutputProviding` protocol and `BufferedOutputCollector` class.
- `Process` helpers for getting flattened or buffered output.
- `OutputStreamKind` supporting enumeration.
- `FileHandle` conformance to `TextOutputStream`.

### Standard Library Helpers

- Strings and text: 
	- `Regex` match operator;
	- `String` Unicode scalar initializer, truncation, and quoted path helpers;
	- `StringProtocol` helpers for changing case, padding, and trimming;
	- `Unicode.Scalar` character initializer.
- Collections:
	- `Collection` helper for transforming an empty collection to `nil`, and a helper for joining optional strings;
	- `KeyValuePairs` formatting helper for monospaced output;
	- `Sequence` `compacted` method;
	- `Set` initializer for strings with a separator.

### Synchronization Helpers

- Atomic property wrappers.

## Using Swift Helpers

### Xcode Project

Add the package dependency using its URL:

```
https://github.com/processed-bits/swift-helpers
```

### Swift Package Manager

Add the package-level dependency on the Swift Helpers package:

```swift
dependencies: [
	.package(url: "https://github.com/processed-bits/swift-helpers", from: "3.0.0"),
]
```

Add target-level dependencies on the required libraries: 

```swift
dependencies: [
	.product(name: "AppKitHelpers", package: "SwiftHelpers"),
	.product(name: "CoreAnimationHelpers", package: "SwiftHelpers"),
	.product(name: "CoreDataHelpers", package: "SwiftHelpers"),
	.product(name: "CoreGraphicsHelpers", package: "SwiftHelpers"),
	.product(name: "DebuggingHelpers", package: "SwiftHelpers"),
	.product(name: "ExitCodeHelpers", package: "SwiftHelpers"),
	.product(name: "FoundationHelpers", package: "SwiftHelpers"),
	.product(name: "FoundationLegacyHelpers", package: "SwiftHelpers"),
	.product(name: "LoggingHelpers", package: "SwiftHelpers"),
	.product(name: "OutputHelpers", package: "SwiftHelpers"),
	.product(name: "StandardLibraryHelpers", package: "SwiftHelpers"),
	.product(name: "SynchronizationHelpers", package: "SwiftHelpers"),
]
```
 
## Documentation

Documentation is available:

- In Xcode, use `Build Documentation` (⌃⇧⌘D) from the `Product` menu.
- Online at [Swift Package Index][spi-documentation].
- As documentation archives, see the ‘DocC Plugin Documentation Archive’ section below.

> [!NOTE] 
> Xcode versions prior to 15 don’t generate documentation for extensions to types from other modules.

### DocC Plugin Documentation Archive

Add a package-level dependency on the DocC plugin:

```swift
dependencies: [
	.package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.3.0"),
],
```

Generate documentation archives, then open them with Xcode to import:

```sh
swift package generate-documentation
```

## Evolution and Compatibility

This package follows the evolution of the Swift language, its cross-platform packages, and aims to support the latest versions of Swift on all Apple platforms and Linux. Compatibility with older Swift versions is not guaranteed, but a reasonable effort is made to support them.

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

---

Copyright © 2022-2025 Stanislav Lomachinskiy. Licensed under the [MIT License](LICENSE.txt).

[spi-package]: https://swiftpackageindex.com/processed-bits/swift-helpers
[spi-documentation]: https://swiftpackageindex.com/processed-bits/swift-helpers/documentation/
[shield-swift-versions]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fprocessed-bits%2Fswift-helpers%2Fbadge%3Ftype%3Dswift-versions
[shield-platforms]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fprocessed-bits%2Fswift-helpers%2Fbadge%3Ftype%3Dplatforms
