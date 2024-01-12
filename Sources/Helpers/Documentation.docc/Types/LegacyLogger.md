# ``LegacyLogger``

## Overview

This object resembles [`os.Logger`](https://developer.apple.com/documentation/os/logger) for earlier versions of deployment targets by wrapping `os_log(_:log:type:)` function:

- iOS 10.0 up to 14.0
- macOS 10.12 up to 11.0
- tvOS 10.0 up to 14.0
- watchOS 3.0 up to 7.0

```swift
let logger = LegacyLogger()
let x = 42
logger.info("The answer is \(x)")
```

You may also add a type alias in the required scope. In this case `LegacyLogger` object will be used in preference of `os.Logger`.

```swift
typealias Logger = LegacyLogger
```

> Important: Contrary to the `os.Logger`, the system *can't* redact the values of interpolated strings for this object. Value formatters and string alignment options are *not* available.
>
> When targeting iOS 14.0 and later, macOS 11.0 and later, tvOS 14.0 and later, and watchOS 7.0 and later *only* use [`os.Logger`](https://developer.apple.com/documentation/os/logger).

For more information, see [Logging](https://developer.apple.com/documentation/os/logging) and [`os.Logger`](https://developer.apple.com/documentation/os/logger).

## Topics

### Creating a Logger

- ``init()``
- ``init(subsystem:category:)``
- ``init(_:)``
- ``default``

### Logging a Message

- ``log(level:_:)``

### Logging a Scoped Message

- ``notice(_:)``
- ``debug(_:)``
- ``trace(_:)``
- ``info(_:)``
- ``error(_:)``
- ``warning(_:)``
- ``fault(_:)``
- ``critical(_:)``

### Logging a Point

- ``point(fileID:line:function:)``
