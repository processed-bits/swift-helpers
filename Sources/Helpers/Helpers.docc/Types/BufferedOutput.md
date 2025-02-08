# ``BufferedOutput``

Use this object to buffer output by streams to print it later, for example, after an asynchronous task finishes. You can print to this object's streams or use ``BufferedOutputCollector`` to read from pipes.

```swift
let bufferedOutput = BufferedOutput()
print("Hello world!", to: &bufferedOutput.output)
print("Hello error!", to: &bufferedOutput.error)
```

Use ``flush()`` to print to the respective streams.

```swift
bufferedOutput.flush()
```

Streams conform to [`TextOutputStream`](https://developer.apple.com/documentation/swift/textoutputstream) and [`TextOutputStreamable`](https://developer.apple.com/documentation/swift/textoutputstreamable). For convenience, `BufferedOutput` itself also conforms to `TextOutputStreamable`.

## Topics

### Creating a Buffered Output Object

- ``init()``

### Output Streams

- ``output``
- ``error``
- ``OutputStream``

### Appending to Buffered Output

- ``append(string:to:)``
- ``append(contentsOf:)``

### Printing Buffered Output

- ``flush()``
- ``write(to:)``
