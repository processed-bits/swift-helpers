// URLComponents+ReferenceKind.swift, 27.11.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation

public extension URLComponents {

	/// URI reference kind according to RFC 3986.
	///
	/// See ``URIReferenceKind`` for more information.
	var referenceKind: URIReferenceKind {
		URIReferenceKind(
			scheme: scheme,
			host: host,
			path: path,
			query: query,
			fragment: fragment
		)
	}

}
