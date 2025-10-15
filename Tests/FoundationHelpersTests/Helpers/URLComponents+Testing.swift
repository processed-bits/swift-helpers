// URLComponents+Testing.swift, 21.12.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation
import FoundationHelpers
import StandardLibraryHelpers
import Testing

extension URLComponents {

	/// Creates URL components for testing.
	init(
		scheme: String? = nil,
		user: String? = nil,
		password: String? = nil,
		host: String? = nil,
		path: String = "",
		query: String? = nil,
		fragment: String? = nil
	) {
		self.init()
		self.scheme = scheme
		self.user = user
		self.password = password
		self.host = host
		self.path = path
		self.query = query
		self.fragment = fragment
	}

	/// Creates encoded URL components for testing.
	///
	/// - Scheme doesn’t use percent-encoding.
	/// - Host accepts percent-encoding, but IDNA encoding is mostly used.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	static func encoded(
		scheme: String? = nil,
		user: String? = nil,
		password: String? = nil,
		host: String? = nil,
		path: String = "",
		query: String? = nil,
		fragment: String? = nil
	) -> Self {
		var components = URLComponents()
		components.scheme = scheme
		components.percentEncodedUser = user
		components.percentEncodedPassword = password
		components.encodedHost = host
		components.percentEncodedPath = path
		components.percentEncodedQuery = query
		components.percentEncodedFragment = fragment
		return components
	}

	/// Creates URL components from string for testing.
	init(
		requireString string: String,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws {
		self = try #require(URLComponents(string: string), sourceLocation: sourceLocation)
	}

	/// Returns a URL based on the component settings and relative to a given base URL.
	func requireURL(
		relativeTo base: URL? = nil,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws -> URL {
		try #require(url(relativeTo: base), "Can’t create a URL from components.", sourceLocation: sourceLocation)
	}

	/// Dumps the URL components. This method is intended only for development of the tests.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@discardableResult func dump(percentEncoded: Bool = false) -> Self {
		let pairs: KeyValuePairs<String, String> = if percentEncoded {
			[
				"Scheme": scheme ?? "nil",
				"Enc. user": percentEncodedUser ?? "nil",
				"Enc. password": percentEncodedPassword ?? "nil",
				"Enc. host": encodedHost ?? "nil",
				"Enc. path": percentEncodedPath,
				"Enc. query": percentEncodedQuery ?? "nil",
				"Enc. fragment": percentEncodedFragment ?? "nil",
				"Reference kind": referenceKind.description,
			]
		} else {
			[
				"Scheme": scheme ?? "nil",
				"User": user ?? "nil",
				"Password": password ?? "nil",
				"Host": host ?? "nil",
				"Port": port?.description ?? "nil",
				"Path": path,
				"Query": query ?? "nil",
				"Fragment": fragment ?? "nil",
				"Reference kind": referenceKind.description,
			]
		}
		print(pairs.formatted(keySuffix: ":"))
		return self
	}

}
