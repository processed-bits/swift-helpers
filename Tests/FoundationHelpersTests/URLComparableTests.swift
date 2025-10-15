// URLComparableTests.swift, 07.11.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation
import FoundationHelpers
import Testing

/// Asserts that each pair of URLs in the array is in sorted order.
@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
private extension URL {
	static func assertSortedOrder(
		ofStrings strings: [String],
		sourceLocation: SourceLocation = #_sourceLocation
	) throws {
		let urls = try strings.map { try URL(requireString: $0, sourceLocation: sourceLocation) }
		assertSortedOrder(of: urls, sourceLocation: sourceLocation)
	}

	static func assertSortedOrder(
		ofFilePaths paths: [String],
		sourceLocation: SourceLocation = #_sourceLocation
	) {
		let urls = paths.map { URL(filePath: $0) }
		assertSortedOrder(of: urls, sourceLocation: sourceLocation)
	}

	static func assertSortedOrder(
		of urls: [URL],
		sourceLocation: SourceLocation = #_sourceLocation
	) {
		for (index, url) in urls.enumerated() {
			let nextIndex = index + 1
			guard nextIndex < urls.count else {
				return
			}
			let nextURL = urls[nextIndex]
			#expect(url < nextURL, sourceLocation: sourceLocation)
		}
	}
}

struct URLComparableTests {

	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func sorting() throws {
		// Simple string URLs.
		try URL.assertSortedOrder(ofStrings: [
			"https://github.com/apple/swift",
			"https://github.com/apple/swift/blob/main/README.md",
			"https://github.com/apple/swift-evolution",
		])

		// Complex string URLs.
		try URL.assertSortedOrder(ofStrings: [
			"https://github.com/apple/swift",
			"ssh://server.local:443",
			"ssh://user:password@server.local:443/path?name=value#fragment",
		])

		// File URLs.
		URL.assertSortedOrder(ofFilePaths: [
			"/A/B/C/",
			"/A/B/C",
			"/A/B C",
			"/A B/C",
			"/File 1",
			"/File 9",
			"/File 11",
			"/File 99",
		])
	}

}
