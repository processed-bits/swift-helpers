// URLBaseURLTests.swift, 05.04.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation
import FoundationHelpers
import Testing

@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
private extension URL {
	@discardableResult func assertIsValidForBaseURL(
		_ expected: Bool = true,
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		let result = isValidForBaseURL
		#expect(result == expected, sourceLocation: sourceLocation)
		return self
	}

	@discardableResult func assertAsBaseURL(
		string expectedString: String,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws -> Self {
		let expected = try URL(requireString: expectedString)
		return try assertAsBaseURL(expected, sourceLocation: sourceLocation)
	}

	@discardableResult func assertAsBaseURL(
		_ expected: URL?,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws -> Self {
		let result = asBaseURL
		#expect(result == expected, sourceLocation: sourceLocation)
		return result ?? self
	}
}

struct URLBaseURLTests {

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func isValidForBaseURL() throws {
		try URL(requireString: "file:").assertIsValidForBaseURL()
		try URL(requireString: "file://").assertIsValidForBaseURL()
		try URL(requireString: "file:///").assertIsValidForBaseURL()
		try URL(requireString: "file:///x").assertIsValidForBaseURL()

		try URL(requireString: "mailto:john.appleseed@apple.com").assertIsValidForBaseURL()

		// No scheme.
		try URL(requireString: "/x").assertIsValidForBaseURL(false)
	}

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func asBaseURL() throws {
		// Absolute URI.
		try URL(requireString: "file:///").assertAsBaseURL(string: "file:///")
		try URL(requireString: "https://github.com").assertAsBaseURL(string: "https://github.com/")
		try URL(requireString: "https://github.com/apple/").assertAsBaseURL(string: "https://github.com/apple/")
		try URL(requireString: "https://github.com/apple/swift.git").assertAsBaseURL(string: "https://github.com/apple/swift.git")
		try URL(requireString: "https://github.com?query=1").assertAsBaseURL(string: "https://github.com/?query=1")

		// Generic URI.
		try URL(requireString: "https://github.com#fragment").assertAsBaseURL(string: "https://github.com/")
		try URL(requireString: "https://github.com?query=1#fragment").assertAsBaseURL(string: "https://github.com/?query=1")
		try URL(requireString: "https://github.com/apple/swift/#getting-started").assertAsBaseURL(string: "https://github.com/apple/swift/")

		// Absolute URI with base.
		try URL(requireString: "?query=1", relativeTo: "https://github.com").assertAsBaseURL(string: "https://github.com/?query=1")

		// Generic URI with base.
		try URL(requireString: "#fragment", relativeTo: "https://github.com").assertAsBaseURL(string: "https://github.com/")
		try URL(requireString: "apple/swift/#getting-started", relativeTo: "https://github.com").assertAsBaseURL(string: "https://github.com/apple/swift/")

		// Non-conforming.
		try URL(requireString: "?query=1").assertAsBaseURL(nil)
		try URL(requireString: "#fragment").assertAsBaseURL(nil)
	}

}
