# ``CallsCounter``

You can count the number of calls (e.g. tasks, operations) with or without an expectation, or the balance of paired calls (e.g. initialization and deinitialization).

**Calls Counter**

```swift
let counter = CallsCounter()
counter.increment()
print("Calls: \(counter).")
// Calls: 1.
```

**Calls Counter with an Expectation**

```swift
let counter = CallsCounter(expectedCount: 100)
counter.increment()
print("Calls: \(counter).")
// Calls: 1 of 100.
```

**Balance Calls Counter**

```swift
let counter = CallsCounter()
counter.increment()
counter.decrement()
print("Balance: \(counter).")
// Balance: 0.
```

## Topics

### Creating a Counter

- ``init(expectedCount:)``

### Increasing and Decreasing the Count

- ``increment()``
- ``decrement()``

### Inspecting the Count

- ``count``
- ``expectedCount``
- ``description``
