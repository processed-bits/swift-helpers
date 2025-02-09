# Swift Helpers

[![][swift-versions-shield]][spi-package]
[![][platforms-shield]][spi-package]

The Swift Helpers package provides miscellaneous helpers for Swift development, including extensions for popular frameworks and custom types. The following overview mentions the most interesting helpers in each collection and isn't exhaustive. Please see [documentation](#documentation) or the source files hierarchy to find more helpers, which may be helpful to you.

Collection | Description
:--- | :---
AppKit | Controllers, input, menus, touch bar, views helpers.
Concurrency | `Atomic` property wrapper.
Core Animation | `CALayer`, `CAMediaTiming` extensions.
Core Data | `NSManagedObject`, `NSManagedObjectContext` extensions.
Core Graphics | `CGFloat`, `CGSize` extensions.
Exit Code | Exit code protocol and helpers for working with exit codes.
Foundation | Bindings, character set, collections, data, file system, operations, processes, threads, scheduling, preferences, resources, strings and text, URLs and URL loading system helpers.
Logging and Debugging | Extended logger, legacy logger, stopwatches, counters, and other helpers.
Output | Helpers for printing to standard error and for output buffering.
Standard Library | Strings and text, collections extensions.

## Adding Swift Helpers as a Dependency

Use Xcode to add the package to a project, or add dependencies manually to a package:

```swift
let package = Package(
    // …
    dependencies: [
        .package(url: "https://github.com/processed-bits/swift-helpers", upToNextMajor(from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "…",
            dependencies: [
                .product(name: "Helpers", package: "swift-helpers"),
            ],
        ),
    ]
)
```
 
## Documentation

Documentation is available:

- in Xcode (use `Build Documentation` (⌃⇧⌘D) from the `Product` menu);
- online: [Swift Package Index][spi-documentation];
- as a documentation archive (see 'DocC Plugin Documentation Archive' next).

> Note: Xcode versions prior to 15 don't generate documentation for extensions to types from other modules.

### DocC Plugin Documentation Archive

Generate a documentation archive, then open it with Xcode to import:

```sh
swift package generate-documentation --include-extended-types
```

## Changelog

Available [here](CHANGELOG.md).

---

Copyright © 2023-2025 Stanislav Lomachinskiy. [MIT License](LICENSE.txt).

[spi-package]: https://swiftpackageindex.com/processed-bits/swift-helpers
[spi-documentation]: https://swiftpackageindex.com/processed-bits/swift-helpers/documentation/
[swift-versions-shield]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fprocessed-bits%2Fswift-helpers%2Fbadge%3Ftype%3Dswift-versions
[platforms-shield]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fprocessed-bits%2Fswift-helpers%2Fbadge%3Ftype%3Dplatforms
