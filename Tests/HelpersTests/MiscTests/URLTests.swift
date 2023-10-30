// URLTests.swift, 17.05.2022-04.05.2023.
// Copyright © 2022-2023 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class URLTests: XCTestCase {

	// MARK: `Comparable` Implementation

	func testSorting() {
		// swiftlint:disable force_unwrapping
		// Test file paths.
		let filePaths = [
			"/A/B/C",
			"/A/B C",
			"/A B/C",
			"/File 1",
			"/File 9",
			"/File 11",
			"/File 99",
		]
		let fileURLs = filePaths.map { URL(fileURLWithPath: $0) }
		checkOrder(of: fileURLs)
		// Test simple URLs.
		let simpleURLStrings = [
			"https://github.com/apple/swift",
			"https://github.com/apple/swift/blob/main/README.md",
			"https://github.com/apple/swift-evolution",
		]
		let simpleURLs = simpleURLStrings.map { URL(string: $0)! }
		checkOrder(of: simpleURLs)
		// Test complex URLs, including access to all parts.
		let complexURLStrings = [
			"https://github.com/apple/swift",
			"ssh://Test%20Server.local:443",
			"ssh://User:password@Test%20Server.local:443/path?test=true#fragment",
		]
		let complexURLs = complexURLStrings.map { URL(string: $0)! }
		checkOrder(of: complexURLs)
		// swiftlint:enable force_unwrapping
	}

	private func checkOrder(of urls: [URL]) {
		for (index, url) in urls.enumerated() {
			let nextIndex = index + 1
			guard nextIndex < urls.count else {
				return
			}
			let nextURL = urls[nextIndex]
			XCTAssertLessThan(url, nextURL)
		}
	}

	// MARK: Relative URLs

	private let base = URL(fileURLWithPath: "/base", isDirectory: true)

	func testNonStandardizedRelativeURLs() {
		let absoluteURL = URL(fileURLWithPath: "/base/./../base/file", isDirectory: false)

		// Relative and relativized URLs must be equal.
		let relativeURL = URL(fileURLWithPath: "file", isDirectory: false, relativeTo: base)
		let relativizedURL = absoluteURL.relativeURL(to: base)
		XCTAssertEqual(relativeURL, relativizedURL)
		XCTAssertEqual(relativeURL.relativePath, relativizedURL.relativePath)
	}

	func testRelativeURLs() throws {
		let fileURL = URL(fileURLWithPath: "file", isDirectory: false, relativeTo: base)
		let stringURL = try XCTUnwrap(URL(string: "string", relativeTo: base))

		// Absolute URLs must differ.
		var mutatedFileURL = fileURL.absoluteURL
		var mutatedStringURL = stringURL.absoluteURL
		XCTAssertNotEqual(fileURL.relativePath, mutatedFileURL.relativePath)
		XCTAssertNotEqual(stringURL.relativePath, mutatedStringURL.relativePath)

		// Relativized URLs must equal original ones.
		mutatedFileURL.relativize(to: base)
		mutatedStringURL.relativize(to: base)
		XCTAssertEqual(fileURL, mutatedFileURL)
		XCTAssertEqual(stringURL, mutatedStringURL)
	}

}
