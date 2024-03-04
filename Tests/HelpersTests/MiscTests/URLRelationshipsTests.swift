// URLRelationshipsTests.swift, 03.03.2024-04.03.2024.
// Copyright © 2024 Stanislav Lomachinskiy.

import XCTest

final class URLRelationshipsTests: XCTestCase {

	// MARK: Descendants

	func testDescendants() throws {
		assertIsDescendant(
			URL(fileURLWithPath: "/Library/Caches", isDirectory: true),
			URL(fileURLWithPath: "/Library", isDirectory: true)
		)
		assertIsDescendant(
			URL(fileURLWithPath: "/Library/Caches", isDirectory: true),
			URL(fileURLWithPath: "/", isDirectory: true)
		)
		try assertIsDescendant(
			XCTUnwrap(URL(string: "https://github.com/apple/")),
			XCTUnwrap(URL(string: "https://github.com"))
		)
		try assertIsDescendant(
			XCTUnwrap(URL(string: "https://github.com/apple/")),
			XCTUnwrap(URL(string: "https://github.com/"))
		)
		try assertIsDescendant(
			XCTUnwrap(URL(string: "https://github.com/apple/swift/")),
			XCTUnwrap(URL(string: "https://github.com/apple/swift.git"))
		)

		// Irrelevant base path.
		assertIsNotDescendant(
			URL(fileURLWithPath: "/Library/Caches", isDirectory: true),
			URL(fileURLWithPath: "", isDirectory: true)
		)
		// Same URLs.
		assertIsNotDescendant(
			URL(fileURLWithPath: "/Library/Caches", isDirectory: true),
			URL(fileURLWithPath: "/Library/Caches", isDirectory: true)
		)

		// Wrong scheme or path component.
		try assertIsNotDescendant(
			XCTUnwrap(URL(string: "ssh://github.com/apple/")),
			XCTUnwrap(URL(string: "https://github.com/apple/"))
		)
		try assertIsNotDescendant(
			XCTUnwrap(URL(string: "https://github.com/apple/swift-evolution.git")),
			XCTUnwrap(URL(string: "https://github.com/apple/swift/"))
		)
	}

	private func assertIsDescendant(_ url: URL, _ parentURL: URL, file: StaticString = #filePath, line: UInt = #line) {
		XCTAssert(url.isDescendant(of: parentURL), file: file, line: line)
	}

	private func assertIsNotDescendant(_ url: URL, _ parentURL: URL, file: StaticString = #filePath, line: UInt = #line) {
		XCTAssertFalse(url.isDescendant(of: parentURL), file: file, line: line)
	}

	// MARK: Relativized URLs

	/// A helper struct, which simplifies URLs construction and relativization tests assertions.
	private struct URLRelativizeTest {
		let baseURL: URL
		let relativeURL: URL
		let absoluteURL: URL
		let onlyDescending: Bool

		init(
			basePath: String, relativePath: String, absolutePath: String,
			baseIsDirectory: Bool = true, isDirectory: Bool = true, onlyDescending: Bool = true
		) {
			baseURL = URL(fileURLWithPath: basePath, isDirectory: baseIsDirectory)
			relativeURL = URL(fileURLWithPath: relativePath, isDirectory: isDirectory, relativeTo: baseURL)
			absoluteURL = URL(fileURLWithPath: absolutePath, isDirectory: isDirectory)
			self.onlyDescending = onlyDescending
		}

		init(
			baseString: String, relativeString: String, absoluteString: String,
			onlyDescending: Bool = true
		) throws {
			baseURL = try XCTUnwrap(URL(string: baseString))
			relativeURL = try XCTUnwrap(URL(string: relativeString, relativeTo: baseURL))
			absoluteURL = try XCTUnwrap(URL(string: absoluteString))
			self.onlyDescending = onlyDescending
		}

		func assertEqual(file: StaticString = #filePath, line: UInt = #line) {
			XCTAssertEqual(relativeURL, absoluteURL.relativized(to: baseURL, onlyDescending: onlyDescending), file: file, line: line)
		}

		func assertNotEqual(file: StaticString = #filePath, line: UInt = #line) {
			XCTAssertNotEqual(relativeURL, absoluteURL.relativized(to: baseURL, onlyDescending: onlyDescending), file: file, line: line)
		}
	}

	func testRelativizedFileURLs() throws {
		// Descendant directory.
		URLRelativizeTest(
			basePath: "/Library", relativePath: "Caches",
			absolutePath: "/Library/Caches"
		).assertEqual()

		// Relative directory.
		URLRelativizeTest(
			basePath: "/Library", relativePath: "../Applications",
			absolutePath: "/Applications",
			onlyDescending: false
		).assertEqual()
		URLRelativizeTest(
			basePath: "/Library", relativePath: "../Applications",
			absolutePath: "/Applications"
		).assertNotEqual()
	}

	func testRelativizedStringURLs() throws {
		// Descendant directory.
		try URLRelativizeTest(
			baseString: "https://github.com/apple/", relativeString: "swift/",
			absoluteString: "https://github.com/apple/swift/"
		).assertEqual()
		try URLRelativizeTest(
			baseString: "https://github.com/apple/", relativeString: "swift-evolution/",
			absoluteString: "https://github.com/apple/swift/"
		).assertNotEqual()

		// Descendant file.
		try URLRelativizeTest(
			baseString: "https://github.com/apple/swift.git", relativeString: "swift/README.md",
			absoluteString: "https://github.com/apple/swift/README.md"
		).assertEqual()
		try URLRelativizeTest(
			baseString: "https://github.com/microsoft/", relativeString: "../apple/swift/README.md",
			absoluteString: "https://github.com/apple/swift/README.md",
			onlyDescending: false
		).assertEqual()

		// Relative directory.
		try URLRelativizeTest(
			baseString: "https://github.com/apple/", relativeString: "../microsoft/",
			absoluteString: "https://github.com/microsoft/",
			onlyDescending: false
		).assertEqual()
		try URLRelativizeTest(
			baseString: "https://github.com/apple/swift/", relativeString: "../../microsoft/",
			absoluteString: "https://github.com/microsoft/",
			onlyDescending: false
		).assertEqual()
		try URLRelativizeTest(
			baseString: "https://github.com/apple/", relativeString: "../microsoft/",
			absoluteString: "https://github.com/microsoft/"
		).assertNotEqual()

		// Relative file.
		try URLRelativizeTest(
			baseString: "https://github.com/apple/swift.git", relativeString: "swift/blob/main/docs/README.md#tutorials",
			absoluteString: "https://github.com/apple/swift/blob/main/docs/README.md#tutorials"
		).assertEqual()
		try URLRelativizeTest(
			baseString: "https://github.com/microsoft/", relativeString: "../apple/swift/blob/main/docs/README.md#tutorials",
			absoluteString: "https://github.com/apple/swift/blob/main/docs/README.md#tutorials",
			onlyDescending: false
		).assertEqual()
		try URLRelativizeTest(
			baseString: "https://github.com/apple/swift.git", relativeString: "swift/issues?q=is%3Aopen",
			absoluteString: "https://github.com/apple/swift/issues?q=is%3Aopen"
		).assertEqual()
	}

}
