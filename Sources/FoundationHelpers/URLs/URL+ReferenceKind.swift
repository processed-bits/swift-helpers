// URL+ReferenceKind.swift, 27.11.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation

public extension URL {

	/// URI reference kind according to RFC 3986.
	///
	/// The reference kind is determined for a URL resolved against its base.
	///
	/// See ``URIReferenceKind`` for more information.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	var referenceKind: URIReferenceKind {
		// Accessing `URL.path(percentEncoded:)` of a relative-path reference (with an empty path), or same-document reference crashes with SIGILL on macOS 13, Swift 6.0, Intel. As a workaround, always try constructing `URLComponents` and return its value.
		if let components = URLComponents(url: self, resolvingAgainstBaseURL: true) {
			return components.referenceKind
		}

		// `URL.path(percentEncoded:)` method implementation contains a bug, see `URLPartsTests.path()` for more information. To account for resolution against a base URL, the path is provided by `absoluteURL`.
		return URIReferenceKind(
			scheme: scheme,
			host: host(percentEncoded: false),
			path: absoluteURL.path(percentEncoded: false),
			query: query(percentEncoded: false),
			fragment: fragment(percentEncoded: false)
		)
	}

}
