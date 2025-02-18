// URLInitializationTests.swift, 17.05.2022-15.02.2025.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import Foundation
import Testing

private extension URL {
	/// Asserts that an initialized URL equals its input or overridden string.
	@discardableResult static func assertInitialized(
		string: String,
		expected: String? = nil,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws -> Self {
		let url = try URL(requireString: string, sourceLocation: sourceLocation)
		let result = url.absoluteString.removingPercentEncoding ?? url.absoluteString
		let expected = expected ?? string
		#expect(result == expected, sourceLocation: sourceLocation)
		return url
	}

	/// Asserts that a URL is initialized to its input or overridden path.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, visionOS 1.0, watchOS 9.0, *)
	@discardableResult static func assertInitialized(
		filePath: String,
		expected: String? = nil,
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		let url = URL(filePath: filePath)
		let result = url.path(percentEncoded: false)
		let expected = expected ?? filePath
		#expect(result == expected, sourceLocation: sourceLocation)
		return url
	}

	/// Asserts that a URL equals a string.
	@discardableResult func assertString(
		_ expected: String,
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		let result = absoluteString.removingPercentEncoding ?? absoluteString
		#expect(result == expected, sourceLocation: sourceLocation)
		return self
	}
}

struct URLInitializationTests {

	// MARK: String URLs

	/// Tests string URLs initialization.
	@Test func string() throws {
		try URL.assertInitialized(string: "/")

		try URL.assertInitialized(string: ".")
		try URL.assertInitialized(string: "./")

		try URL.assertInitialized(string: "/.")
		try URL.assertInitialized(string: "/./")

		try URL.assertInitialized(string: "..")
		try URL.assertInitialized(string: "../")

		try URL.assertInitialized(string: "/..")
		try URL.assertInitialized(string: "/../")

		try URL.assertInitialized(string: "./x/")
		try URL.assertInitialized(string: "../x/")

		try URL.assertInitialized(string: "/./x/")
		try URL.assertInitialized(string: "/../x/")

		try URL.assertInitialized(string: "x/.")
		try URL.assertInitialized(string: "x/./")
		try URL.assertInitialized(string: "x/..")
		try URL.assertInitialized(string: "x/../")

		try URL.assertInitialized(string: "/x/.")
		try URL.assertInitialized(string: "/x/./")
		try URL.assertInitialized(string: "/x/..")
		try URL.assertInitialized(string: "/x/../")

		try URL.assertInitialized(string: " ")
		try URL.assertInitialized(string: "mailto:")

		try URL.assertInitialized(string: "//server.local")
		try URL.assertInitialized(string: "//server.local/")
		try URL.assertInitialized(string: "//server.local/test")
		try URL.assertInitialized(string: "//server.local/test/")
	}

	// MARK: File URLs

	/// Tests file URLs initialization.
	///
	/// Expectations are as of macOS 15.1 implementation:
	///
	/// - an empty path file URL is initialized as `./`;
	/// - relative path file URL `./` prefixes are removed when initialized;
	/// - relative path file URL `/.` or `./` suffixes are removed when initialized.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, visionOS 1.0, watchOS 9.0, *)
	@Test func filePath() throws {
		URL.assertInitialized(filePath: "", expected: "./")
		URL.assertInitialized(filePath: "/")

		URL.assertInitialized(filePath: ".")
		URL.assertInitialized(filePath: "./")

		URL.assertInitialized(filePath: "/.")
		URL.assertInitialized(filePath: "/./")

		URL.assertInitialized(filePath: "..")
		URL.assertInitialized(filePath: "../")

		URL.assertInitialized(filePath: "/..")
		URL.assertInitialized(filePath: "/../")

		URL.assertInitialized(filePath: "./x/", expected: "x/")
		URL.assertInitialized(filePath: "././x/", expected: "x/")
		URL.assertInitialized(filePath: "../x/")

		URL.assertInitialized(filePath: "/./x/")
		URL.assertInitialized(filePath: "/../x/")

		URL.assertInitialized(filePath: "x/.", expected: "x")
		URL.assertInitialized(filePath: "x/./.", expected: "x")
		URL.assertInitialized(filePath: "x/./", expected: "x/")
		URL.assertInitialized(filePath: "x/././", expected: "x/")
		URL.assertInitialized(filePath: "x/..")
		URL.assertInitialized(filePath: "x/../")

		URL.assertInitialized(filePath: "/x/.")
		URL.assertInitialized(filePath: "/x/./")
		URL.assertInitialized(filePath: "/x/..")
		URL.assertInitialized(filePath: "/x/../")
	}

	// MARK: Resolving

	@Test func resolving() throws {
		// Absolute URI.
		try URL(requireString: "https://server.local/x?key=value", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.assertString("https://server.local/x?key=value")

		// Reference starting with authority.
		try URL(requireString: "//server.local/x?key=value", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.assertString("ssh://server.local/x?key=value")

		// Reference starting with an absolute path.
		try URL(requireString: "/x", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.assertString("ssh://server.remote/x")
		try URL(requireString: "/x?key=value", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.assertString("ssh://server.remote/x?key=value")
		try URL(requireString: "/x#fragment", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.assertString("ssh://server.remote/x#fragment")

		// Reference starting with a relative path.
		try URL(requireString: "x", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.assertString("ssh://server.remote/a/b/x")
		try URL(requireString: "x?key=value", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.assertString("ssh://server.remote/a/b/x?key=value")
		try URL(requireString: "x#fragment", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.assertString("ssh://server.remote/a/b/x#fragment")

		// Reference starting with an empty path.
		try URL(requireString: "?key=value", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.assertString("ssh://server.remote/a/b/c?key=value")
		try URL(requireString: "#fragment", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.assertString("ssh://server.remote/a/b/c?k=v#fragment")
		try URL(requireString: "?key=value#fragment", relativeTo: "ssh://server.remote/a/b/c?k=v#drop")
			.assertString("ssh://server.remote/a/b/c?key=value#fragment")
	}

	@Test func abnormalResolving() throws {
		// Absolute URI.
		withKnownIssue("Invalid base URL.", isIntermittent: true) {
			try URL(requireString: "https://server.local/x?key=value", relativeTo: "//server.remote/a/b/c?k=v")
				.assertString("https://server.local/x?key=value")
		}

		// Reference starting with authority.
		withKnownIssue("Invalid base URL.", isIntermittent: true) {
			try URL(requireString: "//server.local/x?key=value", relativeTo: "/a/b/c?k=v")
				.assertString("//server.local/x?key=value")
		}

		// Reference starting with an empty path.
		withKnownIssue("Invalid base URL, no scheme, no authority.") {
			try URL(requireString: "?key=value", relativeTo: "/a/b/c?k=v")
				.assertString("/a/b/c?key=value")
			try URL(requireString: "#fragment", relativeTo: "/a/b/c?k=v")
				.assertString("/a/b/c?k=v#fragment")
		}

		withKnownIssue("Invalid base URL, no authority.") {
			try URL(requireString: "x", relativeTo: "mailto:a")
				.assertString("mailto:x")
		}
	}

	// MARK: Base URL Fragment Stripping

	@Test func baseURLFragmentStripping() throws {
		try URL(requireString: ".", relativeTo: "ssh://server.remote/a/#fragment")
			.assertString("ssh://server.remote/a/")
		try URL(requireString: ".", relativeTo: "ssh://server.remote/a#fragment")
			.assertString("ssh://server.remote/")
		try URL(requireString: "?", relativeTo: "ssh://server.remote/a#fragment")
			.assertString("ssh://server.remote/a?")
		try URL(requireString: "#", relativeTo: "ssh://server.remote/a#fragment")
			.assertString("ssh://server.remote/a#")
		try URL(requireString: "/", relativeTo: "ssh://server.remote/a#fragment")
			.assertString("ssh://server.remote/")

		withKnownIssue("Empty string URL does not change the base URL", isIntermittent: true) {
			try URLComponents(path: "").requireURL(relativeTo: URL(requireString: "ssh://server.remote/a/#fragment"))
				.assertString("ssh://server.remote/a/")
			try URLComponents(requireString: "").requireURL(relativeTo: URL(requireString: "ssh://server.remote/a/#fragment"))
				.assertString("ssh://server.remote/a/")
		}
		try URLComponents(path: ".").requireURL(relativeTo: URL(requireString: "ssh://server.remote/a/#fragment"))
			.assertString("ssh://server.remote/a/")
		try URLComponents(path: ".").requireURL(relativeTo: URL(requireString: "ssh://server.remote/a#fragment"))
			.assertString("ssh://server.remote/")
		try URLComponents(path: "/").requireURL(relativeTo: URL(requireString: "ssh://server.remote/a/#fragment"))
			.assertString("ssh://server.remote/")
	}

	@Test func nestedBaseURL() throws {
		let url = try URL(requireString: "ssh://server.remote/a")
		let baseURL = try URL(requireString: "b/", relativeTo: url)

		try URL(requireString: "x", relativeTo: baseURL).assertString("ssh://server.remote/b/x")
	}

}
