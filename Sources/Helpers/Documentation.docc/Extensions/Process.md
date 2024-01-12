# ``Foundation/Process``

Async running, shell scripts and working with output.

## Topics

### Creating a Shell Script Process Object

- ``init(shell:shellArguments:script:scriptArguments:)``

### Running and Stopping a Process

- ``runUntilExit()``

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
