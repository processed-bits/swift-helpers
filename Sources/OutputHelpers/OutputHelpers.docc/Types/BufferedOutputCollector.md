# ``BufferedOutputCollector``

To collect output, you must create a collector, set up the pipes, initiate output and wait for its end.

```swift
let collector = BufferedOutputCollector()
process.standardOutput = collector.outputPipe
process.standardError = collector.errorPipe
try process.run()
return collector.waitUntilEndOfOutput()
```

`Process` extension implements this functionality using `runUntilEndOfOutput()` and `runUntilEndOfOutput(using:)` methods.

## Topics

### Creating a Collector

- ``init(bufferedOutput:outputPipe:errorPipe:encoding:)``

### Pipes

- ``outputPipe``
- ``errorPipe``

### Getting Buffered Output

- ``waitUntilEndOfOutput()``
