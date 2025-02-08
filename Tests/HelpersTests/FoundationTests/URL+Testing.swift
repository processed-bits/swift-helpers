// URL+Testing.swift, 27.11.2024-08.02.2025.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation
import Helpers
import Testing

extension URL {

	/// Creates a testing URL from the provided string, relative to another URL.
	init(
		requireString string: String,
		relativeTo base: URL? = nil,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws {
		self = try #require(URL(string: string, relativeTo: base), sourceLocation: sourceLocation)
	}

	/// Creates a testing URL from the provided string, relative to another provided string.
	init(
		requireString string: String,
		relativeTo baseString: String,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws {
		let base = try URL(requireString: baseString, sourceLocation: sourceLocation)
		self = try URL(requireString: string, relativeTo: base, sourceLocation: sourceLocation)
	}

	/// Creates a testing file URL that references a path you specify as a string, relative to another base path.
	init(filePath path: String, relativeTo basePath: String) {
		let base = URL(filePath: basePath)
		self = URL(filePath: path, relativeTo: base)
	}

	/// Dumps the URL. This method is intended only for development of the tests.
	@discardableResult func dump() -> Self {
		lazy var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)
		let pairs: KeyValuePairs<String, String> = [
			"URL": description,
			"Absolute URL": absoluteURL.description,
			"String rel.": relativeString,
			"String abs.": absoluteString,
			"Scheme": scheme ?? "nil",
			"User": user(percentEncoded: false) ?? "nil",
			"Password": password(percentEncoded: false) ?? "nil",
			"Host": host(percentEncoded: false) ?? "nil",
			"Port": port?.description ?? "nil",
			"Path rel.": relativePath,
			"Path": path(percentEncoded: false),
			"Path comp.": pathComponents.description,
			"Path URLComp's": urlComponents?.path ?? "nil",
			"Path directory": hasDirectoryPath.description,
			"Query": query(percentEncoded: false) ?? "nil",
			"Fragment": fragment(percentEncoded: false) ?? "nil",
			"Reference kind": referenceKind.description,
		]
		print(pairs.formatted(keySuffix: ":"))
		print()
		return self
	}

}
