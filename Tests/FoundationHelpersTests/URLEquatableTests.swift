// URLEquatableTests.swift, 17.05.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import Foundation
import FoundationHelpers
import Testing

@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
private extension URL {
	/// Asserts that two string URLs are equal or not.
	static func assertEqual(
		_ equal: Bool = true,
		string string1: String,
		relativeTo1 base1: URL? = nil,
		string string2: String,
		relativeTo2 base2: URL? = nil,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws {
		let url1 = try #require(URL(string: string1, relativeTo: base1), sourceLocation: sourceLocation)
		let url2 = try #require(URL(string: string2, relativeTo: base2), sourceLocation: sourceLocation)
		if equal {
			#expect(url1 == url2, sourceLocation: sourceLocation)
		} else {
			#expect(url1 != url2, sourceLocation: sourceLocation)
		}
	}

	/// Asserts that a string URL and a file URL are equal or not.
	static func assertEqual(
		_ equal: Bool = true,
		string: String,
		relativeTo1 base1: URL? = nil,
		filePath: String,
		relativeTo2 base2: URL? = nil,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws {
		let url1 = try #require(URL(string: string, relativeTo: base1), sourceLocation: sourceLocation)
		let url2 = URL(filePath: filePath, relativeTo: base2)
		if equal {
			#expect(url1 == url2, sourceLocation: sourceLocation)
		} else {
			#expect(url1 != url2, sourceLocation: sourceLocation)
		}
	}

	/// Asserts that two file URLs are equal or not.
	static func assertEqual(
		_ equal: Bool = true,
		filePath filePath1: String,
		relativeTo1 base1: URL? = nil,
		filePath filePath2: String,
		relativeTo2 base2: URL? = nil,
		sourceLocation: SourceLocation = #_sourceLocation
	) {
		let url1 = URL(filePath: filePath1, relativeTo: base1)
		let url2 = URL(filePath: filePath2, relativeTo: base2)
		if equal {
			#expect(url1 == url2, sourceLocation: sourceLocation)
		} else {
			#expect(url1 != url2, sourceLocation: sourceLocation)
		}
	}
}

struct URLEquatableTests {

	/// URLs with minor differences in their parts are not equal.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func differingParts() throws {
		// Path directory indication.
		try URL.assertEqual(
			false,
			string: "/Library/Caches/",
			string: "/Library/Caches"
		)
		URL.assertEqual(
			false,
			filePath: "/Library/Caches/",
			filePath: "/Library/Caches"
		)

		// Scheme.
		try URL.assertEqual(
			false,
			string: "https://server.local",
			string: "HTTPS://server.local"
		)

		// User.
		try URL.assertEqual(
			false,
			string: "ftp://user@server.local",
			string: "ftp://User@server.local"
		)

		// Password.
		try URL.assertEqual(
			false,
			string: "ftp://user:password@server.local",
			string: "ftp://user:Password@server.local"
		)

		// Host.
		try URL.assertEqual(
			false,
			string: "ftp://server.local",
			string: "ftp://Server.local"
		)

		// Port.
		try URL.assertEqual(
			false,
			string: "https://server.local",
			string: "https://server.local:443"
		)

		// Path.
		try URL.assertEqual(
			false,
			string: "https://en.wikipedia.org/wiki/URL",
			string: "https://en.wikipedia.org/wiki/url"
		)

		// Query.
		try URL.assertEqual(
			false,
			string: "https://server.local?test=1",
			string: "https://server.local?test=2"
		)

		// Fragment.
		try URL.assertEqual(
			false,
			string: "https://en.wikipedia.org/wiki/URL#Protocol-relative_URLs",
			string: "https://en.wikipedia.org/wiki/URL#protocol-relative_urls"
		)
	}

	/// String and file path URLs are equal.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func stringPath() throws {
		try URL.assertEqual(
			string: "file:///Library/Caches/",
			filePath: "/Library/Caches/"
		)
	}

	/// String and file path URLs with same base are equal.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func stringPathSameBase() throws {
		let base = URL(filePath: "/tmp/")

		try URL.assertEqual(
			string: "foo.zip", relativeTo1: base,
			filePath: "foo.zip", relativeTo2: base
		)
	}

	/// URLs with differing base are not equal.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	@Test func differentBase() throws {
		URL.assertEqual(
			false,
			filePath: "foo.zip", relativeTo1: URL(filePath: "/tmp/"),
			filePath: "tmp/foo.zip", relativeTo2: URL(filePath: "/")
		)
	}

}
