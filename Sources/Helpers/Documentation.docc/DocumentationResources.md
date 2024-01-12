# Documentation Resources

## Online

Online documentation is available at [Swift Package Index](https://swiftpackageindex.com/processed-bits/swift-helpers).

## Xcode-built

Use `Build Documentation` (⌃⇧⌘D) from the `Product` menu.

> Note: Xcode versions prior to 15 don't generate documentation for extensions to types from other modules.

## DocC Plugin

To manually generate a full documentation archive, run from the package folder:

```sh
swift package generate-documentation --include-extended-types
```

Open the generated documentation archive with Xcode to import it.
