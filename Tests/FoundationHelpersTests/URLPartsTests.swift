// URLPartsTests.swift, 05.04.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation
import FoundationHelpers
import Testing

// MARK: - Assertions

private extension URL {
	@discardableResult func assertScheme(
		_ expected: String?,
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		#expect(scheme == expected, sourceLocation: sourceLocation)
		return self
	}

	@discardableResult func assertHost(
		_ expected: String?,
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		#expect(host(percentEncoded: false) == expected, sourceLocation: sourceLocation)
		return self
	}

	@discardableResult func assertPath(
		_ expected: String,
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		#expect(path(percentEncoded: false) == expected, sourceLocation: sourceLocation)
		return self
	}

	@discardableResult func assertDeprecatedPath(
		_ expected: String,
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		#expect(path == expected, sourceLocation: sourceLocation)
		return self
	}

	@discardableResult func assertLastPathComponent(
		_ expected: String,
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		#expect(lastPathComponent == expected, sourceLocation: sourceLocation)
		return self
	}

	@discardableResult func assertStem(
		_ expected: String?,
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		#expect(stem == expected, sourceLocation: sourceLocation)
		return self
	}
}

// MARK: - Tests

struct URLPartsTests {

	// MARK: Scheme

	/// Tests the return values of the `scheme` property.
	@Test func scheme() throws {
		let base = URL(filePath: "/tmp/")

		try URL(requireString: "foo.zip", relativeTo: base)
			.assertScheme("file")

		URL(filePath: "foo.zip", relativeTo: base)
			.assertScheme("file")
	}

	// MARK: Host

	/// Tests the return values of the `host(percentEncoded:)` method.
	@Test func host() throws {
		let base = URL(string: "ftp://server.local")

		try URL(requireString: "foo.zip")
			.assertHost(nil)

		try URL(requireString: "foo.zip", relativeTo: base)
			.assertHost("server.local")

		try URL(requireString: "//acme.com/foo.zip", relativeTo: base)
			.assertHost("acme.com")

		try URL(requireString: "ftp://acme.com/foo.zip", relativeTo: base)
			.assertHost("acme.com")
	}

	// MARK: Path

	/// Tests the return values of the `path(percentEncoded:)` method and the deprecated `path` property.
	///
	/// The implementation of `path(percentEncoded:)` contains a bug.
	///
	/// - The documentation in headers states that it will resolve against the base URL, same as the deprecated `path` property.
	/// - The publicly available documentation has no note on resolving.
	/// - The method does not resolve against the base URL.
	/// - Implementation in the `swift-foundation` repository returns the absolute path.
	@Test(
		.bug("https://github.com/swiftlang/swift-foundation/issues/1011"),
		.bug("https://forums.swift.org/t/url-path-vs-path-percentencoded-for-file-urls/75358")
	)
	func path() throws {
		let base = URL(filePath: "/tmp/")

		try URL(requireString: "foo.zip")
			.assertPath("foo.zip")
			.assertDeprecatedPath("foo.zip")

		try URL(requireString: "foo/")
			.assertPath("foo/")
			.assertDeprecatedPath("foo")

		try URL(requireString: "foo.zip", relativeTo: base)
		#if os(Linux)
			.assertPath("/tmp/foo.zip")
		#else
			.assertPath("foo.zip")
		#endif
			.assertDeprecatedPath("/tmp/foo.zip")

		try URL(requireString: "foo/", relativeTo: base)
		#if os(Linux)
			.assertPath("/tmp/foo/")
		#else
			.assertPath("foo/")
		#endif
			.assertDeprecatedPath("/tmp/foo")

		URL(filePath: "foo.zip", relativeTo: base)
		#if os(Linux)
			.assertPath("/tmp/foo.zip")
		#else
			.assertPath("foo.zip")
		#endif
			.assertDeprecatedPath("/tmp/foo.zip")

		URL(filePath: "foo/", relativeTo: base)
		#if os(Linux)
			.assertPath("/tmp/foo/")
		#else
			.assertPath("foo/")
		#endif
			.assertDeprecatedPath("/tmp/foo")
	}

	// MARK: Last Path Component

	@Test func lastPathComponent() throws {
		try URL(requireString: "foo.zip").assertLastPathComponent("foo.zip")
		try URL(requireString: "foo.tar.gz").assertLastPathComponent("foo.tar.gz")
		try URL(requireString: "/tmp/foo.txt").assertLastPathComponent("foo.txt")
		try URL(requireString: "Xcode.app/").assertLastPathComponent("Xcode.app")
		try URL(requireString: "/Applications/Xcode.app/").assertLastPathComponent("Xcode.app")

		try URL(requireString: ".hidden").assertLastPathComponent(".hidden")
		try URL(requireString: "/tmp/.hidden").assertLastPathComponent(".hidden")

		try URL(requireString: ".").assertLastPathComponent(".")
		try URL(requireString: "/tmp/.").assertLastPathComponent(".")

		try URL(requireString: "..").assertLastPathComponent("..")
		try URL(requireString: "/tmp/..").assertLastPathComponent("..")

		try URL(requireString: "/").assertLastPathComponent("/")
		try URL(requireString: "https://github.com").assertLastPathComponent("")
	}

	// MARK: Stem

	@Test func stringStem() throws {
		try URL(requireString: "foo.zip").assertStem("foo")
		try URL(requireString: "foo.tar.gz").assertStem("foo.tar")
		try URL(requireString: "/tmp/foo.txt").assertStem("foo")
		try URL(requireString: "Xcode.app/").assertStem("Xcode")
		try URL(requireString: "/Applications/Xcode.app/").assertStem("Xcode")

		try URL(requireString: ".hidden").assertStem(".hidden")
		try URL(requireString: "/tmp/.hidden").assertStem(".hidden")

		try URL(requireString: ".").assertStem(".")
		try URL(requireString: "..").assertStem("..")
		try URL(requireString: "/tmp/.").assertStem(".")
		try URL(requireString: "/tmp/..").assertStem("..")

		try URL(requireString: "/").assertStem("/")
		try URL(requireString: "https://github.com").assertStem(nil)
	}

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func filePathStem() throws {
		URL(filePath: "foo.zip").assertStem("foo")
		URL(filePath: "foo.tar.gz").assertStem("foo.tar")
		URL(filePath: "/tmp/foo.txt").assertStem("foo")

		URL(filePath: ".hidden").assertStem(".hidden")
		URL(filePath: "/tmp/.hidden").assertStem(".hidden")

		URL(filePath: "Xcode.app").assertStem("Xcode")
		URL(filePath: "Xcode.app/").assertStem("Xcode")
		URL(filePath: "/Applications/Xcode.app/").assertStem("Xcode")

		URL(filePath: "/tmp/.").assertStem(".")
		URL(filePath: "/tmp/..").assertStem("..")

		URL(filePath: "/").assertStem("/")
		URL(filePath: #"\"#).assertStem(#"\"#)
	}

}
