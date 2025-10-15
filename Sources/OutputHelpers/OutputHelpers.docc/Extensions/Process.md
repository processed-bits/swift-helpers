# ``Foundation/Process``

Helpers for getting flattened or buffered output.

## Topics

### Configuring a Process Object

- ``isUsingStandardOutput``
- ``isUsingStandardError``
- ``detachOutput(outputPipe:errorPipe:)``
- ``detachCombinedOutput(pipe:)``

### Getting Flattened Output of a Process

- ``flatOutput(streamKind:encoding:)``

### Running a Process with Output Buffering

- ``runUntilEndOfOutput()``
- ``runUntilEndOfOutput(using:)``
