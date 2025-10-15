# ``CallCounter``

Count the number of calls (e.g., tasks or operations) with or without an expectation, or the balance of paired calls (e.g., initialization and deinitialization).

**Calls Counter**

```swift
let counter = CallCounter()

// Repeat for every call.
counter.increment()

print("Calls: \(counter).")
// Calls: 1.
```

**Calls Counter with an Expectation**

```swift
let counter = CallCounter(expectedCount: 100)

// Repeat for every call.
counter.increment()

print("Calls: \(counter).")
// Calls: 1 of 100.
```

**Balance Calls Counter**

```swift
let counter = CallCounter()

// Repeat for every call pair.
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

### Describing the Count

- ``description``
