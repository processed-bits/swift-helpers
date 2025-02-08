// URLEquatableTests.swift, 17.05.2022-02.12.2024.
// Copyright © 2022-2024 Stanislav Lomachinskiy.

import Foundation
import Testing

private extension URL {
	/// Asserts that two string URLs are equal or not.
	static func assertEqual(
		_ equal: Bool = true,
		string string1: String,
		string string2: String,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws {
		let url1 = try #require(URL(string: string1), sourceLocation: sourceLocation)
		let url2 = try #require(URL(string: string2), sourceLocation: sourceLocation)
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
		filePath: String,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws {
		let url1 = try #require(URL(string: string), sourceLocation: sourceLocation)
		let url2 = URL(filePath: filePath)
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
		filePath filePath2: String,
		sourceLocation: SourceLocation = #_sourceLocation
	) {
		let url1 = URL(filePath: filePath1)
		let url2 = URL(filePath: filePath2)
		if equal {
			#expect(url1 == url2, sourceLocation: sourceLocation)
		} else {
			#expect(url1 != url2, sourceLocation: sourceLocation)
		}
	}
}

struct URLEquatableTests {

	@Test func equality() throws {
		try URL.assertEqual(
			string: "file:///Library/Caches/",
			filePath: "/Library/Caches/"
		)

		// Differing directory indication.
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

		// Differing protocol.
		try URL.assertEqual(
			false,
			string: "https://server.local",
			string: "HTTPS://server.local"
		)

		// Differing user.
		try URL.assertEqual(
			false,
			string: "ftp://user@server.local",
			string: "ftp://User@server.local"
		)

		// Differing password.
		try URL.assertEqual(
			false,
			string: "ftp://user:password@server.local",
			string: "ftp://user:Password@server.local"
		)

		// Differing host.
		try URL.assertEqual(
			false,
			string: "ftp://server.local",
			string: "ftp://Server.local"
		)

		// Differing port.
		try URL.assertEqual(
			false,
			string: "https://server.local",
			string: "https://server.local:443"
		)

		// Differing path.
		try URL.assertEqual(
			false,
			string: "https://en.wikipedia.org/wiki/URL",
			string: "https://en.wikipedia.org/wiki/url"
		)

		// Differing fragment.
		try URL.assertEqual(
			false,
			string: "https://en.wikipedia.org/wiki/URL#Protocol-relative_URLs",
			string: "https://en.wikipedia.org/wiki/URL#protocol-relative_urls"
		)
	}

}
