# ``Foundation/URL``

URL helpers, `Comparable` conformance.

## Topics

### Reference Kind

- ``referenceKind``

### Accessing the Parts of a URL

- ``stem``
- ``filenameComponents``

### Validating and Deriving a Base URL

- ``isValidForBaseURL``
- ``asBaseURL``

### Normalizing URLs

- ``normalize(resolvingAgainstBaseURL:lowercasePath:schemePortPairs:removeEmptyPathComponents:)``
- ``normalized(resolvingAgainstBaseURL:lowercasePath:schemePortPairs:removeEmptyPathComponents:)``
- ``lexicallyNormalize(resolvingAgainstBaseURL:removeEmptyPathComponents:)``
- ``lexicallyNormalized(resolvingAgainstBaseURL:removeEmptyPathComponents:)``

### Relativizing URLs

- ``isRelative(of:)``
- ``relativize(to:allowAscending:)``
- ``relativized(to:allowAscending:)``

### Working with File URLs

- ``expandingHomeDirectory``

### Deprecated

- ``expandingTildeInPath``
