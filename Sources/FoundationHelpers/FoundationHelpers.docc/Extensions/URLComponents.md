# ``Foundation/URLComponents``

URL components helpers.

## Topics

### Reference Kind

- ``referenceKind``

### Validating and Deriving a Base URL

- ``isValidForBaseURL``
- ``asBaseURL``

### Normalization

- ``normalize(lowercasePath:schemePortPairs:removeEmptyPathComponents:)``

### Syntax-Based Normalization

- ``normalizeCase(lowercasePath:)``
- ``normalizePercentEncoding(skipHost:)``
- ``normalizePathLexically(removeEmptyComponents:)``

### Scheme-Based Normalization

- ``normalizePort(schemePortPairs:)``
- ``defaultNormalizedPorts``
- ``normalizeEmptyPath()``
