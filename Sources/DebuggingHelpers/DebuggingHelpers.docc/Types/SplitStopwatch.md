# ``SplitStopwatch``

`SplitStopwatch` extends `Stopwatch` by adding the ``split(at:)`` method and the ``laps`` property.

Each lap is represented by a separate `Stopwatch` instance. Use their ``Stopwatch/measurement``, ``Stopwatch/description`` or other properties to get information about separate laps.

- Note: The `laps` array is manipulated automatically. Don’t manually manipulate the lap stopwatches.

See ``Stopwatch`` for more information.

## Topics

### Creating a Stopwatch

- ``init(start:)``

### Manipulating a Stopwatch

- ``start(at:)``
- ``stop(at:)``
- ``split(at:)``
- ``reset()``

### Inspecting a Stopwatch

- ``Stopwatch/measurement``
- ``laps``
- ``Stopwatch/isRunning``

### Describing a Stopwatch

- ``Stopwatch/description``
- ``debugDescription``

### Formatting String Representations

- ``Stopwatch/formatStyle``
- ``Stopwatch/formatter``
