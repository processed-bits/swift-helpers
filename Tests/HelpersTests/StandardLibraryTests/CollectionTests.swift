// CollectionTests.swift, 19.08.2022-05.05.2023.
// Copyright © 2022-2023 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class CollectionTests: XCTestCase {

	func testNilIfEmpty() {
		// Arrays.
		let array = ["Test"]
		let emptyArray: [String] = []
		XCTAssertEqual(array.nilIfEmpty, array)
		XCTAssertNil(emptyArray.nilIfEmpty)
		// Strings.
		let string = "Test"
		let emptyString = ""
		XCTAssertEqual(string.nilIfEmpty, Optional.some(string))
		XCTAssertNil(emptyString.nilIfEmpty)
		// Substrings.
		let substring = Substring(string)
		let emptySubstring = Substring(emptyString)
		XCTAssertEqual(substring.nilIfEmpty, Optional.some(substring))
		XCTAssertNil(emptySubstring.nilIfEmpty)
	}

	func testJoinedOptionals() {
		let someStrings = ["A", nil, "B", "C", nil]
		let noStrings: [String?] = [nil, nil]
		XCTAssertEqual(someStrings.joined(), "ABC")
		XCTAssertNil(noStrings.joined())
	}

}
