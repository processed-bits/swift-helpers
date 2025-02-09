# Documentation Resources

## Xcode Documentation

Use `Build Documentation` (⌃⇧⌘D) from the `Product` menu.

> Note: Xcode versions prior to 15 don't generate documentation for extensions to types from other modules.

## Online Documentation

Available at [Swift Package Index](https://swiftpackageindex.com/processed-bits/swift-helpers/documentation/).

## DocC Plugin Documentation Archive

Generate documentation archive, then open it with Xcode to import:

```sh
swift package generate-documentation --include-extended-types
```
