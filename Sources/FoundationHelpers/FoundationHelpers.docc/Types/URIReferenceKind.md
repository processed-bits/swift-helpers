# ``URIReferenceKind``

## Default Implementation

The default initializer implementation (which is used by respective `URL`’s ``Foundation/URL/referenceKind`` and `URLComponents`’ ``FoundationHelpers/Foundation/URLComponents/referenceKind`` properties) uses a “first-match-wins” algorithm. 

This also means that some secondary syntax requirements are relaxed and not checked. For example, the first path component of `path-absolute`, `path-noscheme`, or `path-rootless` is not checked to be non-zero; also the first path component of `path-noscheme` is not checked to not contain a colon. 

The overall approach is sufficient for most applications. If stricter parsing is required, you may extend this type with a failable or throwing initializer.

## Topics

### URI and Nested Kinds

- ``uri(_:)``
- ``URIReferenceKind/URIKind``

### Relative Reference and Nested Kinds

- ``relativeReference(_:)``
- ``URIReferenceKind/URIRelativeReferenceKind``

### Default Initializer

- ``init(scheme:host:path:query:fragment:)``
