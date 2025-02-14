// URLReferenceKindTests.swift, 27.11.2024-10.01.2025.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation
import Helpers
import Testing

private extension URL {
	@discardableResult func assertReferenceKind(_ expected: URIReferenceKind, sourceLocation: SourceLocation = #_sourceLocation) -> Self {
		let result = referenceKind
		#expect(result == expected, sourceLocation: sourceLocation)
		return self
	}
}

struct URLReferenceKindTests {

	@Test func general() throws {
		// Generic URI.
		try URL(requireString: "https://server.local/x#fragment").assertReferenceKind(.uri(.generic))

		// Absolute URI.
		try URL(requireString: "https://server.local").assertReferenceKind(.uri(.absolute))
		try URL(requireString: "https://server.local/").assertReferenceKind(.uri(.absolute))
		try URL(requireString: "https://server.local/x").assertReferenceKind(.uri(.absolute))
		try URL(requireString: "mailto:john.appleseed@apple.com").assertReferenceKind(.uri(.absolute))
		try URLComponents(scheme: "mailto", path: "john.appleseed@apple.com").requireURL().assertReferenceKind(.uri(.absolute))
		URL(filePath: "/tmp").assertReferenceKind(.uri(.absolute))
		URL(filePath: "tmp").assertReferenceKind(.uri(.absolute))

		// Network-path reference.
		try URL(requireString: "//server.local").assertReferenceKind(.relativeReference(.networkPath))
		try URL(requireString: "//server.local/").assertReferenceKind(.relativeReference(.networkPath))
		try URL(requireString: "//server.local/x").assertReferenceKind(.relativeReference(.networkPath))
		try URLComponents(requireString: "//server.local").requireURL().assertReferenceKind(.relativeReference(.networkPath))
		try URLComponents(host: "server.local").requireURL().assertReferenceKind(.relativeReference(.networkPath))

		// Absolute-path reference.
		try URL(requireString: "/x").assertReferenceKind(.relativeReference(.absolutePath))

		// Relative-path reference.
		try URL(requireString: "x").assertReferenceKind(.relativeReference(.relativePath))
		try URL(requireString: "./x").assertReferenceKind(.relativeReference(.relativePath))
		try URL(requireString: "../x").assertReferenceKind(.relativeReference(.relativePath))
		try URL(requireString: "?").assertReferenceKind(.relativeReference(.relativePath))
		try URL(requireString: "?key=value").assertReferenceKind(.relativeReference(.relativePath))
		try URL(requireString: "?key=value#fragment").assertReferenceKind(.relativeReference(.relativePath))

		// Same-document reference.
		try URLComponents(path: "").requireURL().assertReferenceKind(.relativeReference(.sameDocument))
		try URLComponents(requireString: "").requireURL().assertReferenceKind(.relativeReference(.sameDocument))
		try URL(requireString: "#").assertReferenceKind(.relativeReference(.sameDocument))
		try URL(requireString: "#fragment").assertReferenceKind(.relativeReference(.sameDocument))
		try URLComponents(requireString: "#").requireURL().assertReferenceKind(.relativeReference(.sameDocument))
		try URLComponents(requireString: "#fragment").requireURL().assertReferenceKind(.relativeReference(.sameDocument))
	}

	/// If the first component of a relative-path reference contains a colon, it must be preceded by a current directory component.
	///
	/// If not preceded, it will be wrongly parsed as an absolute URI when initialized as `URL` string.
	///
	/// See RFC 3986 [Section 4.2](https://datatracker.ietf.org/doc/html/rfc3986#section-4.2) for more information.
	@Test func colonInPath() throws {
		try URLComponents(path: "x:y").requireURL().assertReferenceKind(.relativeReference(.relativePath))
		try URL(requireString: "./x:y").assertReferenceKind(.relativeReference(.relativePath))
		try URL(requireString: "x%3Ay").assertReferenceKind(.relativeReference(.relativePath))
	}

	/// Suffix reference will be wrongly parsed as:
	///
	/// - a network-path reference when creating `URLComponents` with an explicit host;
	/// - a relative-path reference when initialized as `URL` or `URLComponents` string.
	///
	/// See RFC 3986 [Section 4.5](https://datatracker.ietf.org/doc/html/rfc3986#section-4.5) for more information.
	@Test func suffixReference() throws {
		// Wrong reference kind.
		try URLComponents(host: "www.apple.com").requireURL().assertReferenceKind(.relativeReference(.networkPath))

		// Wrong reference kind.
		try URLComponents(requireString: "www.apple.com").requireURL().assertReferenceKind(.relativeReference(.relativePath))
		try URL(requireString: "www.apple.com").assertReferenceKind(.relativeReference(.relativePath))
	}

}
