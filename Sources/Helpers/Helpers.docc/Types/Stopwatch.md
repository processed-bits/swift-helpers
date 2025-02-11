# ``Stopwatch``

You don't need to manually start or stop a stopwatch in simple scenarios. When used for measurement of a single scope, you can create a stopwatch and defer printing the result at the beginning of the scope:

```swift
let stopwatch = Stopwatch()
defer { print("Done in \(stopwatch).") }
```

`Stopwatch` is not limited to a single scope. For example, you can create a stopwatch in an initializer and print the result in a method or deinitializer.

- Note: Providing an exact `date` when creating or manipulating a stopwatch allows synchronization of actions in advanced scenarios with multiple stopwatches. See ``SplitStopwatch`` code as an example of such implementation. 

`Stopwatch` provides locale-aware string representations of measurements for ``description`` and ``debugDescription`` properties using its format style. It is possible to alter the format by updating the corresponding type property value, though it is generally advised to use ``measurement`` to generate custom format string representations.

## Topics

### Creating a Stopwatch

- ``init(start:)``

### Manipulating a Stopwatch

- ``start(at:)``
- ``stop(at:)``
- ``reset()``

### Inspecting a Stopwatch

- ``measurement``
- ``isRunning``

### Describing a Stopwatch

- ``description``
- ``debugDescription``

### Formatting String Representations

- ``measurementFormatStyle``
- ``measurementFormatter``
