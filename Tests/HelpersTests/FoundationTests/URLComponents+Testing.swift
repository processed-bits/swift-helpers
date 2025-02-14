// URLComponents+Testing.swift, 21.12.2024-08.02.2025.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation
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

	/// Creates percent-encoded URL components for testing.
	static func percentEncoded(
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
		return try #require(url(relativeTo: base), "Can't create a URL from components.", sourceLocation: sourceLocation)
	}

	/// Dumps the URL components. This method is intended only for development of the tests.
	@discardableResult func dump(percentEncoded: Bool = false) -> Self {
		let pairs: KeyValuePairs<String, String> = if percentEncoded {
			[
				"Scheme": scheme ?? "nil",
				"PE user": percentEncodedUser ?? "nil",
				"PE password": percentEncodedPassword ?? "nil",
				"PE host": encodedHost ?? "nil",
				"PE path": percentEncodedPath,
				"PE query": percentEncodedQuery ?? "nil",
				"PE fragment": percentEncodedFragment ?? "nil",
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
		print()
		return self
	}

}
