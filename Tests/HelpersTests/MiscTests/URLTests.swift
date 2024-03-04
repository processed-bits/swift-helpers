// URLTests.swift, 17.05.2022-04.03.2024.
// Copyright © 2022-2024 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class URLTests: XCTestCase {

	// MARK: `Equatable` Implementation

	func testEquality() throws {
		XCTAssertEqual(
			URL(fileURLWithPath: "/Library/Caches", isDirectory: true),
			try XCTUnwrap(URL(string: "file:///Library/Caches/"))
		)
		XCTAssertNotEqual(
			URL(fileURLWithPath: "/Library/Caches", isDirectory: true),
			URL(fileURLWithPath: "/Library/Caches", isDirectory: false)
		)
		XCTAssertNotEqual(
			try XCTUnwrap(URL(string: "file:///Library/Caches")),
			try XCTUnwrap(URL(string: "file:///Library/Caches/"))
		)
		XCTAssertNotEqual(
			try XCTUnwrap(URL(string: "ssh://user:password@server.local:443/path?key=value#fragment")),
			try XCTUnwrap(URL(string: "ssh://user:password@server.local:443/path?key=value#fragment2"))
		)
	}

	// MARK: `Comparable` Implementation

	/// Asserts that each pair of URLs in the array is in sorted order.
	private func assertSortedOrder(of urls: [URL], file: StaticString = #filePath, line: UInt = #line) {
		for (index, url) in urls.enumerated() {
			let nextIndex = index + 1
			guard nextIndex < urls.count else {
				return
			}
			let nextURL = urls[nextIndex]
			XCTAssertLessThan(url, nextURL, file: file, line: line)
		}
	}

	func testSorting() throws {
		// File URLs.
		let fileURLs = [
			"/A/B/C",
			"/A/B C",
			"/A B/C",
			"/File 1",
			"/File 9",
			"/File 11",
			"/File 99",
		].map { URL(fileURLWithPath: $0) }
		assertSortedOrder(of: fileURLs)

		// Simple URLs.
		let simpleURLs = try [
			"https://github.com/apple/swift",
			"https://github.com/apple/swift/blob/main/README.md",
			"https://github.com/apple/swift-evolution",
		].map { try XCTUnwrap(URL(string: $0)) }
		assertSortedOrder(of: simpleURLs)

		// Complex URLs.
		let complexURLs = try [
			"https://github.com/apple/swift",
			"ssh://server.local:443",
			"ssh://user:password@server.local:443/path?name=value#fragment",
		].map { try XCTUnwrap(URL(string: $0)) }
		assertSortedOrder(of: complexURLs)
	}

}
