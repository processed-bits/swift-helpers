# URL Handling

@Options {
	@AutomaticSeeAlso(disabled)
}

URL parsing peculiarities and related extensions.

## Overview

This article covers parsing peculiarities of [`URL`](https://developer.apple.com/documentation/foundation/url) and [`URLComponents`](https://developer.apple.com/documentation/foundation/urlcomponents) from the Foundation framework, and related extensions, that are provided in this package.

A uniform resource locator (URL, defined earlier in [RFC 1738][rfc1738]) is a specific type of uniform resource identifier (URI, defined later in [RFC 3986][rfc3986]). The two terms are often used interchangeably. Foundation framework doesn’t have a separate type for URIs, but the `URL` and `URLComponents` types handle both URLs with hierarchical paths and generic URIs.

> Important: For apps linked on or after iOS 17 and aligned OS versions, `URL` parsing has updated from the obsolete RFC 1738/1808 parsing to the same RFC 3986 parsing as `URLComponents`. This unifies the parsing behaviors of the `URL` and `URLComponents` APIs.

## File Path URL Initialization

`URL`’s [`init(filePath:directoryHint:relativeTo:)`](https://developer.apple.com/documentation/foundation/url/3988464-init) has the following parsing peculiarities:

- relative paths get current working directory as a base URL, if no base is specified;
- an empty path is initialized as “`./`”;
- “`./`” path prefixes are removed when followed by other path components;
- “`./`” or “`/.`” relative path suffixes are removed when preceded by other path components.

## Base URLs

Contrary to RFC 3986, `URL` and `URLComponents` allow [relative reference](<doc:URIReferenceKind/relativeReference(_:)>) base URLs.  Network-path, absolute-path, and relative-path relative references are supported.

When resolving against a relative reference base URL and if neither URL, nor base URL have a host, then the resulting URL will effectively be a network-path relative reference with an empty host preceded by two slashes (`//`). A `URL` instance will incorrectly report a nil host (but two slashes are added in its string form), a `URLComponents` instance will have an empty host (with expected two slashes in its string form).

According to RFC 3986, `URL` and `URLComponents` will strip any fragment component of a base URL when resolving (except for a highly unusual case of an empty string URL against a base URL).

This package provides extensions for validating and deriving a base URL according to RFC 3986.

Type | Member
--- | ---
`URL` | ``Foundation/URL/isValidForBaseURL``
`URL` | ``Foundation/URL/asBaseURL``
`URLComponents` | ``Foundation/URLComponents/isValidForBaseURL``
`URLComponents` | ``Foundation/URLComponents/asBaseURL``

See RFC 3986 [Section 5.1][rfc3986-5.1] for more information.

## Percent-Encoding of User and Password Components

A plain colon is used to delimit user and password components in a string form. It is not among allowed (thus, non-percent-encoded) characters in the [`urlUserAllowed`](https://developer.apple.com/documentation/foundation/characterset/1780246-urluserallowed) and [`urlPasswordAllowed`](https://developer.apple.com/documentation/foundation/characterset/1780126-urlpasswordallowed) character sets.  Despite that, `URLComponents`’ `user` and `password` property setters do not percent-encode a colon.

To create user or password components with a percent-encoded colon, use `URL` or `URLComponents` string initializer, or `URLComponents`’ `percentEncodedUser` and `percentEncodedPassword` properties with an already encoded string, for example:

```swift
var components = URLComponents()
components.percentEncodedUser = someString.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed)
```

Related normalization methods, that are provided by this package, encode colons in the user and password components.

See RFC 3986 [Section 6.2.2.1][rfc3986-6.2.2.1] and [Section 6.2.2.2][rfc3986-6.2.2.2] for more information.

## See Also

- <doc:URLNormalization>
- ``Foundation/URL``
- ``Foundation/URLComponents``

[rfc1738]: https://datatracker.ietf.org/doc/html/rfc1738
[rfc3986]: https://datatracker.ietf.org/doc/html/rfc3986
[rfc3986-5.1]: https://datatracker.ietf.org/doc/html/rfc3986#section-5.1
[rfc3986-6.2.2.1]: https://datatracker.ietf.org/doc/html/rfc3986#section-6.2.2.1
[rfc3986-6.2.2.2]: https://datatracker.ietf.org/doc/html/rfc3986#section-6.2.2.2
