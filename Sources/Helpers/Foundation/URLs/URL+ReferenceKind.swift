// URL+ReferenceKind.swift, 27.11.2024-24.01.2025.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation

public extension URL {

	/// URI reference kind according to RFC 3986.
	///
	/// The reference kind is determined for a URL resolved against a base.
	///
	/// See ``URIReferenceKind`` for more information.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, visionOS 1.0, watchOS 9.0, *)
	var referenceKind: URIReferenceKind {
		// To account for resolution against a base URL, host and path should be provided by an `absoluteURL`. Scheme, query and fragment are provided as for an already resolved URL.
		URIReferenceKind(
			scheme: scheme,
			host: absoluteURL.host(percentEncoded: false),
			path: absoluteURL.path(percentEncoded: false),
			query: query(percentEncoded: false),
			fragment: fragment(percentEncoded: false)
		)
	}

}
