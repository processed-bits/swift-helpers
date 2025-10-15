// URLInitializationTests.swift, 17.05.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import Foundation
import Testing

extension URL {
	/// Asserts that an initialized URL relative string equals its input or overridden string.
	@discardableResult static func assertInitialized(
		string: String,
		expected: String? = nil,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws -> Self {
		let url = try URL(requireString: string, sourceLocation: sourceLocation)
		return try url.assertRelativeString(expected ?? string, sourceLocation: sourceLocation)
	}

	/// Asserts that a initialized file URL relative path equals its input or overridden path.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@discardableResult static func assertInitialized(
		filePath: String,
		expected: String? = nil,
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		let url = URL(filePath: filePath)
		return url.assertRelativePath(expected ?? filePath, sourceLocation: sourceLocation)
	}

	/// Asserts that a URL relative string equals a given string.
	@discardableResult fileprivate func assertRelativeString(
		// swiftlint:disable:previous strict_fileprivate
		_ expected: String,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws -> Self {
		let result = try #require(relativeString.removingPercentEncoding)
		#expect(result == expected, sourceLocation: sourceLocation)
		return self
	}

	/// Asserts that a URL relative path equals a given path.
	@discardableResult private func assertRelativePath(
		_ expected: String,
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		// Get relative path using `URLComponents`, as `relativePath` drops trailing path separator.
		let result = URLComponents(url: self, resolvingAgainstBaseURL: false)?.path
		#expect(result == expected, sourceLocation: sourceLocation)
		return self
	}
}

struct URLInitializationTests {

	// MARK: String URLs

	/// Tests absolute string URLs initialization.
	@Test func absoluteString() throws {
		try URL.assertInitialized(string: "/")

		try URL.assertInitialized(string: "/.")
		try URL.assertInitialized(string: "/./")

		try URL.assertInitialized(string: "/./x/")
		try URL.assertInitialized(string: "/x/.")
		try URL.assertInitialized(string: "/x/./")

		try URL.assertInitialized(string: "/..")
		try URL.assertInitialized(string: "/../")

		try URL.assertInitialized(string: "/../x/")
		try URL.assertInitialized(string: "/x/..")
		try URL.assertInitialized(string: "/x/../")

		try URL.assertInitialized(string: "//server.local")
		try URL.assertInitialized(string: "//server.local/")
		try URL.assertInitialized(string: "//server.local/test")
		try URL.assertInitialized(string: "//server.local/test/")
	}

	/// Tests relative string URLs initialization.
	@Test func relativeString() throws {
		try URL.assertInitialized(string: ".")
		try URL.assertInitialized(string: "./")

		try URL.assertInitialized(string: "./x/")
		try URL.assertInitialized(string: "x/.")
		try URL.assertInitialized(string: "x/./")

		try URL.assertInitialized(string: "..")
		try URL.assertInitialized(string: "../")

		try URL.assertInitialized(string: "../x/")
		try URL.assertInitialized(string: "x/..")
		try URL.assertInitialized(string: "x/../")
	}

	// MARK: File URLs

	/// Tests absolute file URLs initialization.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func absoluteFilePath() throws {
		URL.assertInitialized(filePath: "/")

		URL.assertInitialized(filePath: "/.")
		URL.assertInitialized(filePath: "/./")

		URL.assertInitialized(filePath: "/./x/")
		URL.assertInitialized(filePath: "/x/.")
		URL.assertInitialized(filePath: "/x/./")

		URL.assertInitialized(filePath: "/..")
		URL.assertInitialized(filePath: "/../")

		URL.assertInitialized(filePath: "/../x/")
		URL.assertInitialized(filePath: "/x/..")
		URL.assertInitialized(filePath: "/x/../")
	}

	/// Tests relative file URLs initialization.
	///
	/// Observations of macOS 15.1 implementation:
	///
	/// - an empty path is initialized as “`./`”;
	/// - “`./`” path prefixes are removed when followed by other path components;
	/// - “`./`” or “`/.`” relative path suffixes are removed when preceded by other path components.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func relativeFilePath() throws {
		withKnownIssue(.urlInitRelativeFilePathTransformation) {
			URL.assertInitialized(filePath: "", expected: "./")
		} when: {
			Condition.isLinux && Condition.isCompiler6_0
		}

		URL.assertInitialized(filePath: ".")
		URL.assertInitialized(filePath: "./")

		withKnownIssue(.urlInitRelativeFilePathTransformation) {
			URL.assertInitialized(filePath: "./x/", expected: "x/")
			URL.assertInitialized(filePath: "././x/", expected: "x/")

			URL.assertInitialized(filePath: "x/.", expected: "x")
			URL.assertInitialized(filePath: "x/./.", expected: "x")
			URL.assertInitialized(filePath: "x/./", expected: "x/")
			URL.assertInitialized(filePath: "x/././", expected: "x/")
		} when: {
			Condition.isLinux
		}

		URL.assertInitialized(filePath: "..")
		URL.assertInitialized(filePath: "../")

		URL.assertInitialized(filePath: "../x/")
		URL.assertInitialized(filePath: "x/..")
		URL.assertInitialized(filePath: "x/../")
	}

	// MARK: Resolving

	@Test func resolving() throws {
		// Absolute URI.
		try URL(requireString: "https://server.local/x?key=value", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.absoluteURL.assertRelativeString("https://server.local/x?key=value")

		// Reference starting with authority.
		try URL(requireString: "//server.local/x?key=value", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.absoluteURL.assertRelativeString("ssh://server.local/x?key=value")

		// Reference starting with an absolute path.
		try URL(requireString: "/x", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.absoluteURL.assertRelativeString("ssh://server.remote/x")
		try URL(requireString: "/x?key=value", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.absoluteURL.assertRelativeString("ssh://server.remote/x?key=value")
		try URL(requireString: "/x#fragment", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.absoluteURL.assertRelativeString("ssh://server.remote/x#fragment")

		// Reference starting with a relative path.
		try URL(requireString: "x", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.absoluteURL.assertRelativeString("ssh://server.remote/a/b/x")
		try URL(requireString: "x?key=value", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.absoluteURL.assertRelativeString("ssh://server.remote/a/b/x?key=value")
		try URL(requireString: "x#fragment", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.absoluteURL.assertRelativeString("ssh://server.remote/a/b/x#fragment")

		// Reference starting with an empty path.
		try URL(requireString: "?key=value", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.absoluteURL.assertRelativeString("ssh://server.remote/a/b/c?key=value")
		try URL(requireString: "#fragment", relativeTo: "ssh://server.remote/a/b/c?k=v")
			.absoluteURL.assertRelativeString("ssh://server.remote/a/b/c?k=v#fragment")
		try URL(requireString: "?key=value#fragment", relativeTo: "ssh://server.remote/a/b/c?k=v#drop")
			.absoluteURL.assertRelativeString("ssh://server.remote/a/b/c?key=value#fragment")
	}

	@Test func abnormalResolving() throws {
		// Absolute URI resolving against an invalid base (no scheme).
		try URL(requireString: "https://server.local/x?key=value", relativeTo: "//server.remote/a/b/c?k=v")
			.absoluteURL.assertRelativeString("https://server.local/x?key=value")

		// Reference starting with a host resolving against an invalid base (no scheme).
		try URL(requireString: "//server.local/x?key=value", relativeTo: "/a/b/c?k=v")
			.absoluteURL.assertRelativeString("//server.local/x?key=value")

		// Reference starting with an empty path resolving against an invalid base (no scheme).
		try withKnownIssue(.urlResolvingAgainstInvalidBase) {
			try URL(requireString: "?key=value", relativeTo: "/a/b/c?k=v")
				.absoluteURL.assertRelativeString("/a/b/c?key=value")
			try URL(requireString: "#fragment", relativeTo: "/a/b/c?k=v")
				.absoluteURL.assertRelativeString("/a/b/c?k=v#fragment")
		} when: {
			!Condition.isLinux
		}

		// Resolving against a valid, but non-hierarchical path base.
		try withKnownIssue(.urlResolvingAgainstNoHostBase) {
			try URL(requireString: "x", relativeTo: "mailto:a")
				.absoluteURL.assertRelativeString("mailto:x")

			try URLComponents(requireString: "x")
				.requireURL(relativeTo: URL(requireString: "mailto:a"))
				.absoluteURL.assertRelativeString("mailto:x")

			try URLComponents(path: "x")
				.requireURL(relativeTo: URL(requireString: "mailto:a"))
				.absoluteURL.assertRelativeString("mailto:x")
		} when: {
			!Condition.isLinux
		}
	}

	// MARK: Base URL Fragment Stripping

	@Test func baseURLFragmentStripping() throws {
		try URL(requireString: ".", relativeTo: "ssh://server.remote/a/#fragment")
			.absoluteURL.assertRelativeString("ssh://server.remote/a/")
		try URL(requireString: ".", relativeTo: "ssh://server.remote/a#fragment")
			.absoluteURL.assertRelativeString("ssh://server.remote/")
		try URL(requireString: "?", relativeTo: "ssh://server.remote/a#fragment")
			.absoluteURL.assertRelativeString("ssh://server.remote/a?")
		try URL(requireString: "#", relativeTo: "ssh://server.remote/a#fragment")
			.absoluteURL.assertRelativeString("ssh://server.remote/a#")
		try URL(requireString: "/", relativeTo: "ssh://server.remote/a#fragment")
			.absoluteURL.assertRelativeString("ssh://server.remote/")

		try URLComponents(path: ".").requireURL(relativeTo: URL(requireString: "ssh://server.remote/a/#fragment"))
			.absoluteURL.assertRelativeString("ssh://server.remote/a/")
		try URLComponents(path: ".").requireURL(relativeTo: URL(requireString: "ssh://server.remote/a#fragment"))
			.absoluteURL.assertRelativeString("ssh://server.remote/")
		try URLComponents(path: "/").requireURL(relativeTo: URL(requireString: "ssh://server.remote/a/#fragment"))
			.absoluteURL.assertRelativeString("ssh://server.remote/")
	}

	// MARK: Nested Base URL

	@Test func nestedBaseURL() throws {
		let url = try URL(requireString: "ssh://server.remote/a")
		let baseURL = try URL(requireString: "b/", relativeTo: url)

		try URL(requireString: "x", relativeTo: baseURL)
			.absoluteURL.assertRelativeString("ssh://server.remote/b/x")
	}

}
