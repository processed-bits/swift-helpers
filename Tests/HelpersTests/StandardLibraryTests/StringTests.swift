// StringTests.swift, 23.11.2022-05.04.2024.
// Copyright © 2022-2024 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class StringTests: XCTestCase {

	private let string = "Mary had a little lamb, his fleece was white as snow"

	// MARK: Truncating

	func testLongTruncation() {
		let truncatedString = string.truncated(to: 99)
		XCTAssertEqual(truncatedString, string)
	}

	func testShortTruncation() {
		for length in 0 ..< String.defaultTruncationTerminator.count {
			let truncatedString = string.truncated(to: length)
			let prefixedString = String(string.prefix(length))
			XCTAssertEqual(truncatedString, prefixedString)
		}
	}

	func testRemovingCharactersTruncation() {
		guard let commaIndex = string.firstIndex(of: ",") else {
			XCTFail("String does not contain a `,`.")
			return
		}
		let truncationLength = string.distance(from: string.startIndex, to: commaIndex) + String.defaultTruncationTerminator.count
		// Removing extra characters.
		for length in truncationLength ... truncationLength + 2 {
			let truncatedString = string.truncated(to: length)
			XCTAssertEqual(truncatedString, "Mary had a little lamb…")
		}
		// Not removing extra characters.
		let truncatedString = string.truncated(to: truncationLength - 1)
		XCTAssertEqual(truncatedString, "Mary had a little lam…")
	}

}
