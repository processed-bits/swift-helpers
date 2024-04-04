# Swift Helpers

Miscellaneous extensions and objects.

Collection | Description
:--- | :---
AppKit | Controllers, input, menus, touch bar, views helpers.
Concurrency | `Atomic` property wrapper.
Core Animation | `CALayer`, `CAMediaTiming` extensions.
Core Data | `NSManagedObject`, `NSManagedObjectContext` extensions.
Core Graphics | `CGFloat`, `CGSize` extensions.
Exit Code | Exit code protocol and helpers for working with exit codes.
Foundation | Bindings, collections, file system, operations, processes, threads, scheduling, preferences, resources, strings and text, URLs and URL loading system helpers.
Logging and Debugging | Extended logger, legacy logger, stopwatches, counters, and other helpers.
Output | Helpers for printing to standard error and for output buffering.
Standard Library | Strings and text, collections extensions.

> Note: This overview mentions the most important helpers in each collection and isn't meant to be exhaustive.

## Adding Swift Helpers as a Dependency

Use Xcode to add the package to a project, or add dependencies manually to a package:

```swift
let package = Package(
    // …
    dependencies: [
        .package(url: "https://github.com/processed-bits/swift-helpers", upToNextMajor(from: "2.1.1"),
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

### Xcode Documentation

Use `Build Documentation` (⌃⇧⌘D) from the `Product` menu.

> Note: Xcode versions prior to 15 don't generate documentation for extensions to types from other modules.

### Online Documentation

Available at [Swift Package Index](https://swiftpackageindex.com/processed-bits/swift-helpers/documentation/).

### DocC Plugin Documentation Archive

Generate documentation archive, then open it with Xcode to import:

```sh
swift package generate-documentation --include-extended-types
```

## Changelog

Available [here](CHANGELOG.md).

---

Copyright © 2023-2024 Stanislav Lomachinskiy. [MIT License](LICENSE.txt).
