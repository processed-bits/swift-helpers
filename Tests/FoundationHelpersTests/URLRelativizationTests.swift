// URLRelativizationTests.swift, 03.03.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation
import FoundationHelpers
import Testing

@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
private extension URL {
	/// Asserts that the URL is relativized against a base string as a given relative string.
	@discardableResult func assertRelativized(
		toString baseString: String,
		expectedString: String?,
		expectedBaseString: String? = nil,
		allowAscending: Bool = false,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws -> Self {
		assert(expectedBaseString != baseString, "Remove redundant `expectedBaseString` parameter.", file: #fileID, line: UInt(sourceLocation.line))

		let base = try URL(requireString: baseString, sourceLocation: sourceLocation)
		let expected: URL? = if let expectedString {
			try URL(requireString: expectedString, relativeTo: expectedBaseString ?? baseString, sourceLocation: sourceLocation)
		} else {
			nil
		}
		return assertRelativized(to: base, expected: expected, allowAscending: allowAscending, sourceLocation: sourceLocation)
	}

	/// Asserts that the URL is relativized against a base path as a given relative path.
	@discardableResult func assertRelativized(
		toFilePath basePath: String,
		expectedPath: String?,
		expectedBasePath: String? = nil,
		allowAscending: Bool = false,
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		assert(expectedBasePath != basePath, "Remove redundant `expectedBasePath` parameter.", file: #fileID, line: UInt(sourceLocation.line))

		let base = URL(filePath: basePath)
		let expected: URL? = if let expectedPath {
			URL(filePath: expectedPath, relativeTo: expectedBasePath ?? basePath)
		} else {
			nil
		}
		return assertRelativized(to: base, expected: expected, allowAscending: allowAscending, sourceLocation: sourceLocation)
	}

	/// Asserts that the URL is relativized against a base URL as a given relative URL.
	@discardableResult func assertRelativized(
		to base: URL,
		expected: URL?,
		allowAscending: Bool = false,
		sourceLocation: SourceLocation = #_sourceLocation
	) -> Self {
		let result = relativized(to: base, allowAscending: allowAscending)
		#expect(result == expected, sourceLocation: sourceLocation)

		if let result {
			// Additionally check that a resulting URL is a relative of base.
			#expect(result.isRelative(of: base), sourceLocation: sourceLocation)
		}

		return result ?? self
	}
}

struct URLRelativizationTests {

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func stringURLs() throws {
		// Directory.
		try URL(requireString: "https://github.com/apple/swift/").assertRelativized(
			toString: "https://github.com",
			expectedString: "apple/swift/",
			expectedBaseString: "https://github.com/"
		)
		try URL(requireString: "https://github.com/apple/swift/").assertRelativized(
			toString: "https://github.com/",
			expectedString: "apple/swift/"
		)
		try URL(requireString: "https://github.com/apple/swift/").assertRelativized(
			toString: "https://github.com/apple/",
			expectedString: "swift/"
		)

		// Same directory.
		try URL(requireString: "https://github.com/apple/").assertRelativized(
			toString: "https://github.com/apple/",
			expectedString: "./"
		)

		// Same directory with query.
		try URL(requireString: "https://github.com/apple/swift/issues/?q=is%3Aopen").assertRelativized(
			toString: "https://github.com/apple/swift/issues/",
			expectedString: "?q=is%3Aopen"
		)

		// Same directory with fragment.
		try URL(requireString: "https://github.com/apple/swift/#contributing-to-swift").assertRelativized(
			toString: "https://github.com/apple/swift/#getting-started",
			expectedString: "#contributing-to-swift",
			expectedBaseString: "https://github.com/apple/swift/"
		)

		// File.
		try URL(requireString: "https://github.com/apple/swift/README.md").assertRelativized(
			toString: "https://github.com/apple/swift/",
			expectedString: "README.md"
		)
		try URL(requireString: "https://github.com/apple/swift/README.md").assertRelativized(
			toString: "https://github.com/apple/swift.git",
			expectedString: "swift/README.md"
		)

		// File with query.
		try URL(requireString: "https://github.com/apple/swift/issues?q=is%3Aopen").assertRelativized(
			toString: "https://github.com/apple/swift.git",
			expectedString: "swift/issues?q=is%3Aopen"
		)

		// File with fragment.
		try URL(requireString: "https://github.com/apple/swift/blob/main/docs/README.md#tutorials").assertRelativized(
			toString: "https://github.com/apple/swift.git",
			expectedString: "swift/blob/main/docs/README.md#tutorials"
		)
		try URL(requireString: "https://github.com/apple/swift/blob/main/README.md").assertRelativized(
			toString: "https://github.com/apple/swift/#getting-started",
			expectedString: "blob/main/README.md",
			expectedBaseString: "https://github.com/apple/swift/"
		)

		// Same file.
		try URL(requireString: "https://github.com/apple/swift.git").assertRelativized(
			toString: "https://github.com/apple/swift.git",
			expectedString: "swift.git"
		)

		// Same file with query.
		try URL(requireString: "https://github.com/apple/swift/issues?q=is%3Aopen").assertRelativized(
			toString: "https://github.com/apple/swift/issues",
			expectedString: "issues?q=is%3Aopen"
		)

		// Same file with fragment.
		try URL(requireString: "https://github.com/apple/swift/index.php#contributing-to-swift").assertRelativized(
			toString: "https://github.com/apple/swift/index.php#getting-started",
			expectedString: "index.php#contributing-to-swift",
			expectedBaseString: "https://github.com/apple/swift/index.php"
		)
	}

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func ascendingStringURLs() throws {
		// Directory.
		try URL(requireString: "https://github.com/").assertRelativized(
			toString: "https://github.com/apple/",
			expectedString: "../",
			allowAscending: true
		)
		try URL(requireString: "https://github.com/").assertRelativized(
			toString: "https://github.com/apple/",
			expectedString: nil
		)
		try URL(requireString: "https://github.com/microsoft/").assertRelativized(
			toString: "https://github.com/apple/",
			expectedString: "../microsoft/",
			allowAscending: true
		)
		try URL(requireString: "https://github.com/microsoft/").assertRelativized(
			toString: "https://github.com/apple/",
			expectedString: nil
		)
		try URL(requireString: "https://github.com/microsoft/").assertRelativized(
			toString: "https://github.com/apple/swift/",
			expectedString: "../../microsoft/",
			allowAscending: true
		)
		try URL(requireString: "https://github.com/").assertRelativized(
			toString: "https://github.com/apple/swift/",
			expectedString: "../../",
			allowAscending: true
		)
		try URL(requireString: "https://github.com/microsoft/").assertRelativized(
			toString: "https://github.com/apple/swift/README.md",
			expectedString: "../../microsoft/",
			allowAscending: true
		)

		// File.
		try URL(requireString: "https://github.com/apple/swift/README.md").assertRelativized(
			toString: "https://github.com/microsoft/",
			expectedString: "../apple/swift/README.md",
			allowAscending: true
		)
		try URL(requireString: "https://github.com/apple/swift/README.md").assertRelativized(
			toString: "https://github.com/microsoft/",
			expectedString: nil
		)

		// File with fragment.
		try URL(requireString: "https://github.com/apple/swift/blob/main/docs/README.md#tutorials").assertRelativized(
			toString: "https://github.com/microsoft/",
			expectedString: "../apple/swift/blob/main/docs/README.md#tutorials",
			allowAscending: true
		)
		try URL(requireString: "https://github.com/apple/swift/blob/main/docs/README.md#tutorials").assertRelativized(
			toString: "https://github.com/microsoft/",
			expectedString: nil
		)
	}

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func fileURLs() throws {
		// Directory.
		URL(filePath: "/Library/Caches/").assertRelativized(
			toFilePath: "/Library/",
			expectedPath: "Caches/"
		)

		// File.
		URL(filePath: "/tmp/build.log").assertRelativized(
			toFilePath: "/tmp/",
			expectedPath: "build.log"
		)
	}

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func ascendingFileURLs() throws {
		// Directory.
		URL(filePath: "/Applications/").assertRelativized(
			toFilePath: "/Library/",
			expectedPath: "../Applications/",
			allowAscending: true
		)
		URL(filePath: "/Applications/").assertRelativized(
			toFilePath: "/Library/",
			expectedPath: nil
		)

		// File.
		URL(filePath: "/build.log").assertRelativized(
			toFilePath: "/tmp/",
			expectedPath: "../build.log",
			allowAscending: true
		)
		URL(filePath: "/build.log").assertRelativized(
			toFilePath: "/tmp/",
			expectedPath: nil
		)
	}

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func other() throws {
		// Relative-path reference base URL.
		try URL(requireString: "https://github.com/apple/swift/").assertRelativized(
			to: URL(requireString: "apple/", relativeTo: "https://github.com/"),
			expected: URL(requireString: "swift/", relativeTo: "https://github.com/apple/")
		)

		// Non-conforming base.
		try URL(requireString: "https://github.com/apple/swift/").assertRelativized(
			toString: "//github.com/apple/",
			expectedString: nil
		)
		try URL(requireString: "https://github.com/apple/swift/").assertRelativized(
			toString: "apple/",
			expectedString: nil
		)

		// URLs with empty path components.
		try URL(requireString: "https://github.com//").assertRelativized(
			toString: "https://github.com/",
			expectedString: ".//"
		)
		try URL(requireString: "https://github.com//apple/swift/").assertRelativized(
			toString: "https://github.com",
			expectedString: ".//apple/swift/",
			expectedBaseString: "https://github.com/"
		)
		try URL(requireString: "https://github.com/apple//swift/").assertRelativized(
			toString: "https://github.com/apple/",
			expectedString: ".//swift/"
		)
		try URL(requireString: "https://github.com/apple/swift//").assertRelativized(
			toString: "https://github.com/apple/",
			expectedString: "swift//"
		)
	}

}
