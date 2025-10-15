# URL Normalization

@Options {
	@AutomaticSeeAlso(disabled)
}

URL normalization extensions and comparison to other implementations.

## Overview

While `URL`’s `standardized` and `FilePath`’s `lexicallyNormalized()` may be sufficient for many applications, this package provides overall normalization and lexical normalization methods, that offer a more flexible and consistent approach based on RFC 3986.

For a list of related properties and methods provided by the Foundation and System frameworks, and notes on them, see [Other Implementations](#Other-Implementations) at the end of this article.

## Normalization

For overall normalization, use these methods:

Type | Member
--- | ---
`URL` | ``Foundation/URL/normalize(resolvingAgainstBaseURL:lowercasePath:schemePortPairs:removeEmptyPathComponents:)``
`URL` | ``Foundation/URL/normalized(resolvingAgainstBaseURL:lowercasePath:schemePortPairs:removeEmptyPathComponents:)``
`URLComponents` | ``Foundation/URLComponents/normalize(lowercasePath:schemePortPairs:removeEmptyPathComponents:)``

For schemes using hierarchical paths (like `file`, `ftp`, `https`), invoke with the default parameters or opt-in to collapse consecutive path separators:

```swift
let url = URL(string: "HTTPS://eXAMPLE.com/./a/../b/c")
url.normalized()
// "https://example.com/b/c"

// Relative URL.
URL(string: "x/../y/./z").normalized()
// "y/z"

// Relative URL, not resolving against a base.
URL(string: "x/../y/./z", relativeTo: url).normalized()
// "y/z -- HTTPS://eXAMPLE.com/./a/../b/c"

// Relative URL, resolving against a base.
URL(string: "x/../y/./z", relativeTo: url).normalized(resolvingAgainstBaseURL: true)
// "https://example.com/b/y/z"
```

For schemes using opaque case-insensitive paths (like `mailto`), opt-in to convert the path to lowercase:

```swift
URL(string: "MailTo:John.Appleseed@apple.com").normalized(lowercasePath: true)
// "mailto:john.appleseed@apple.com"
```

### Notes on Normalization

- Normalizes case. Allows for optional case normalization of a path.
- Normalizes percent-encoding. See [URL Handling](<doc:URLHandling#Percent-Encoding-of-User-and-Password-Components>) for more information on percent-encoding of user and password components.
- Normalizes port. Allows passing a custom dictionary of scheme and default port assignments.
- Normalizes path. See [Notes on Lexical Normalization](#Notes-on-Lexical-Normalization) further, all of them apply. Additionally normalizes an empty path when authority is present.

If you need a further customized normalization algorithm (for example, including validation of a base URL, removal of user and password components, or overriding the default parameters), you can add your own implementation, either wrapping the normalization method, or using the methods, described in [Stages of Normalization](#Stages-of-Normalization).

## Lexical Normalization

For *lexical-only* normalization, use these methods:

Type | Member
--- | ---
`URL` | ``Foundation/URL/lexicallyNormalize(resolvingAgainstBaseURL:removeEmptyPathComponents:)``
`URL` | ``Foundation/URL/lexicallyNormalized(resolvingAgainstBaseURL:removeEmptyPathComponents:)``
`URLComponents` | ``Foundation/URLComponents/normalizePathLexically(removeEmptyComponents:)``

### Notes on Lexical Normalization

- Allows for normalization of relative-path references without a base URL or without resolving against one, retaining leading parent directory components (`..`). See [URL Handling](<doc:URLHandling#Base-URLs>) for more information on handling of base URLs.
- Allows for optional removal of empty path components, effectively collapsing consecutive path separators.
- Consistently preserves directory reference: retains trailing separator (`/`); resolves trailing current directory (`.`) and parent directory (`..`) components as a directory reference.
- Correctly handles relative-path references with a colon (`:`) in the first component or with an empty first component.

## Stages of Normalization 

The above-mentioned normalization methods are in turn using the following methods, that are implemented on `URLComponents` and correspond to RFC 3986 [Section 6.2.2][rfc3986-6.2.2] and [Section 6.2.3][rfc3986-6.2.3]:

Member | Normalization Kind | RFC 3986
--- | --- | ---
``Foundation/URLComponents/normalizeCase(lowercasePath:)`` | Syntax-based | [Section 6.2.2.1][rfc3986-6.2.2.1]
``Foundation/URLComponents/normalizePercentEncoding(skipHost:)`` | Syntax-based | [Section 6.2.2.2][rfc3986-6.2.2.2]
``Foundation/URLComponents/normalizePathLexically(removeEmptyComponents:)`` | Syntax-based | [Section 6.2.2.3][rfc3986-6.2.2.3] 
``Foundation/URLComponents/normalizePort(schemePortPairs:)`` | Scheme-based | [Section 6.2.3][rfc3986-6.2.3]
``Foundation/URLComponents/normalizeEmptyPath()`` | Scheme-based | [Section 6.2.3][rfc3986-6.2.3]

## Other Implementations

The Foundation and System frameworks provide the following properties and methods for standardization or *lexical* normalization of URLs and paths:

Type | Member | Note
--- | --- | ---
`URL` | [`standardized`](https://developer.apple.com/documentation/foundation/url/2293170-standardized) |
`URL` | [`standardizedFileURL`](https://developer.apple.com/documentation/foundation/url/2293229-standardizedfileurl) | File URLs only
`URL` | [`standardize()`](https://developer.apple.com/documentation/foundation/url/2293141-standardize) | File URLs only
`FilePath` | [`lexicallyNormalize()`](https://developer.apple.com/documentation/system/filepath/lexicallynormalize()) | File paths only
`FilePath` | [`lexicallyNormalized()`](https://developer.apple.com/documentation/system/filepath/lexicallynormalized()) | File paths only
`NSString` | [`standardizingPath`](https://developer.apple.com/documentation/foundation/nsstring/1407194-standardizingpath) | Legacy
`NSURL` | [`standardizingPath`](https://developer.apple.com/documentation/foundation/nsurl/1414302-standardizingpath) | Legacy, file paths only

### Notes on URL Standardization

The [`standardized`](https://developer.apple.com/documentation/foundation/url/2293170-standardized) property offers to resolve any instances of “`..`” or “`.`” in its path (more commonly being referred to as “lexical normalization”).

- Does not collapse multiple path separators.
- Does not correctly handle relative-path references with a colon (`:`) in the first component.
- A relative path drops leading parent directory components (`..`).
	- “`../x`” → “`x`”
	- “`../x/`” → “`x/`”
- Trailing parent directory component (`..`) is resolved as a non-directory reference when not followed by a separator (`/`).
	- “`x/y/..`” → “`x`”
	- “`x/y/../`” → “`x/`”
	- “`/x/y/..`” → “`/x`”
	- “`/x/y/../`” → “`/x/`”
- An absolute path drops leading slash (`/`) when the path has “`/..`” suffix and the path is resolved to zero components.
	- “`/x/..`” → “”
	- “`/x/../`” → “`/`”
- Inconsistently resolves leading parent directory component (`..`) in some abnormal examples. 
	- “`/../x`” → “`x`” for absolute-path relative references.
	- “`/../x`” → “`/x`” for generic URIs.
- Inconsistently resolves trailing parent directory component (`..`) in some abnormal examples. 
	- “`/..`” → “” for absolute-path relative references.
	- “`/..`” → “`/`” for generic URIs.
	- “`/../`” → “”

### Notes on FilePath Lexical Normalization

The [`lexicallyNormalized()`](https://developer.apple.com/documentation/system/filepath/lexicallynormalized()) method is one of the latest implementations of lexical normalization provided by a built-in framework.

On construction, `FilePath` will normalize separators by removing redundant intermediary separators and stripping any trailing separators. This is not in line with the latest `URL` initializers, which take a directory hint parameter, and the default is to infer whether a path references a directory based on whether a URL has a trailing separator.

- Collapses consecutive path separators on initialization.
- Trailing separator (`/`) is stripped by `FilePath` on initialization.
	- “`x/`” → “`x`”
	- “`/x/`” → “`/x`”
- Trailing current directory (`.`) and parent directory (`..`) components are resolved as a non-directory reference.
	- “`x/.`” → “`x`”
	- “`x/y/..`” → “`x`”

## See Also

- <doc:URLHandling>
- ``Foundation/URL``
- ``Foundation/URLComponents``

[rfc3986-6.2.2]: https://datatracker.ietf.org/doc/html/rfc3986#section-6.2.2
[rfc3986-6.2.2.1]: https://datatracker.ietf.org/doc/html/rfc3986#section-6.2.2.1
[rfc3986-6.2.2.2]: https://datatracker.ietf.org/doc/html/rfc3986#section-6.2.2.2
[rfc3986-6.2.2.3]: https://datatracker.ietf.org/doc/html/rfc3986#section-6.2.2.3
[rfc3986-6.2.3]: https://datatracker.ietf.org/doc/html/rfc3986#section-6.2.3
