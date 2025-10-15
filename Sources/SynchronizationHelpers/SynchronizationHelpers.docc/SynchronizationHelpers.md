# ``SynchronizationHelpers``

@Metadata {
	@DisplayName("Synchronization Helpers")
}

Atomic property wrappers.

## Overview

Atomic wrappers are helpful when it is not possible to use other means of serializing access to a value like Swift concurrency or actors.

## Usage

```swift
import SynchronizationHelpers
```

## Choosing an Atomic Wrapper

When choosing between atomic property wrappers for thread-safe access to a value, it is important to consider the specific requirements of your application, such as the frequency of read and write operations, the need for reentrancy, and platform constraints.

Performance difference between high-level and low-level wrappers is insignificant when performing less than 10 000 operations. For larger volumes, low-level wrappers provide significant performance improvement.

### High-Level Atomic Wrappers

- `AtomicSerial`: Uses a serial `DispatchQueue` to ensure all reads and writes happen in order. Suitable when most operations modify value, and a concurrent queue does not provide significant benefits.
- `AtomicConcurrent`: Uses a concurrent `DispatchQueue` with barriers for writes. Suitable when read operations are frequent and write operations are less frequent.

### Low-Level Atomic Wrappers

- `Locked`: Uses `NSLock` for thread-safe access. Uses POSIX threads to implement its locking behavior. Simple and efficient for most use cases but does not support reentrancy.
- `RecursiveLocked`: Uses `NSRecursiveLock` for thread-safe access. Supports reentrancy, making it suitable for recursive locking scenarios.
- `UnfairLocked`: Uses `OSAllocatedUnfairLock` for thread-safe access. Provides high-performance locking, available only on newer platforms.

### Comparison

Wrapper | Lock Type | Reentrancy | Platform Availability | Use Case
--- | --- | --- | --- | ---
`AtomicSerial` | Serial `DispatchQueue`| No | All | Frequent value modifications
`AtomicConcurrent`| Concurrent `DispatchQueue`| No | All | Frequent reads, infrequent writes
`Locked` | `NSLock` | No | All | General-purpose, non-reentrant
`RecursiveLocked`| `NSRecursiveLock` | Yes | All | Recursive locking scenarios
`UnfairLocked` | `OSAllocatedUnfairLock`| No | Limited | High-performance

## Performing Atomic Operations

> Important: When multiple operations must be performed atomically (for example, when the code both reads and writes the value), it is mandatory to perform them in a closure, passing it to `withLock` method of the property wrapper's projected value'.

```swift
@Wrapper var counter: Int = 0
$counter.withLock { $0 += 1 }

@Wrapper var numbers: [Int] = []
$numbers.withLock { numbers in
	numbers.append(42)
}
```

## Topics

### High-Level Atomic Wrappers

- ``AtomicSerial``
- ``AtomicConcurrent``

### Low-Level Atomic Wrappers

- ``Locked``
- ``RecursiveLocked``
- ``UnfairLocked``
