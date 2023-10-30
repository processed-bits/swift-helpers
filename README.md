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
Miscellaneous | `URL` extension, `URLBookmark` object.
Networking | `HTTPURLResponse` extension.
Operations | `BlockOperation`, `OperationQueue` extensions.
Output | Helpers for printing to standard error and for output buffering.
Preferences | Property wrappers for the user’s defaults database.
Process | `Process` extensions for async running, shell scripts, working with output.
Regex | `Regex` match operator, `NSRegularExpression`, `NSTextCheckingResult`, `String` extensions.
Resources | `Bundle` extension.
Standard | Basic values, strings and text, collections extensions.
TouchBar | `NSTouchBar` extension, a workaround for alert items.
Views | Helpers for views, images, bindings, responder chain.

> Note: This overview mentions the most important helpers in each collection and isn't meant to be exhaustive.

Changelog is available [here](CHANGELOG.md).

## Documentation Resources

### Online

Online documentation is available at [Swift Package Index](https://swiftpackageindex.com/processed-bits/swift-helpers).

### Xcode-built

Use `Build Documentation` (⌃⇧⌘D) from the `Product` menu.

> Note: Xcode versions prior to 15 don't generate documentation for extensions to types from other modules.

### DocC Plugin

To manually generate a full documentation archive, run from the package folder:

```sh
swift package generate-documentation --include-extended-types
```

Open the generated documentation archive with Xcode to import it.

---

Copyright © 2023 Stanislav Lomachinskiy. [MIT License](LICENSE.txt).
