# Swift Helpers

Miscellaneous extensions and objects.

Collection | Description
--- | ---
Concurrency | `Atomic` property wrapper.
Controllers | `NSTreeController` extension.
CoreAnimation | `CALayer`, `CAMediaTiming` extensions.
CoreData | `NSManagedObject`, `NSManagedObjectContext` extensions.
CoreGraphics | `CGFloat`, `CGSize` extensions.
ExitCode | Exit code protocol and helpers for working with exit codes.
Logging and Debugging | Extended logger, legacy logger, stopwatches, counters, and other helpers.
Menus | `NSMenuItem` extension.
Miscellaneous | `URL` extensions, `URLBookmark` struct.
Networking | `HTTPURLResponse` extension.
Operations | `BlockOperation`, `OperationQueue` extensions.
Output | Helpers for printing to standard error and for output buffering.
Preferences | Property wrappers for the user’s defaults database.
Process | `Process` extensions for async running, shell scripts, working with output.
Regex | `Regex` match operator, `NSRegularExpression`, `NSTextCheckingResult`, `String` extensions.
Resources | `Bundle` extension.
Standard | Strings and text, collections extensions.
TouchBar | `NSTouchBar` extension, a workaround for alert items.
Views | Helpers for views, images, bindings, responder chain.

> Note: This overview mentions the most important helpers in each collection and isn't meant to be exhaustive.

## Adding Swift Helpers as a Dependency

Use Xcode to add the package to a project, or add dependencies manually to a package:

```swift
let package = Package(
    // …
    dependencies: [
        .package(url: "https://github.com/processed-bits/swift-helpers", upToNextMajor(from: "2.0.0"),
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
