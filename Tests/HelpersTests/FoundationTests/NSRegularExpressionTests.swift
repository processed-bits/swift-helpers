// NSRegularExpressionTests.swift, 20.08.2022-16.11.2022.
// Copyright © 2022 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class NSRegularExpressionTests: XCTestCase {

	func testMatchingStrings() throws {
		let string = "abc"
		let pattern = "[a-z]"
		let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
		XCTAssertTrue(regex ~= string)
		XCTAssertEqual(regex.numberOfMatches(in: string), 3)
		XCTAssertEqual(regex.matches(in: string).count, 3)
		XCTAssertNotNil(regex.firstMatch(in: string))
	}

	func testNonMatchingStrings() throws {
		let string = "abc"
		let pattern = "[0-9]"
		let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
		XCTAssertFalse(regex ~= string)
		XCTAssertEqual(regex.numberOfMatches(in: string), 0)
		XCTAssertEqual(regex.matches(in: string).count, 0)
		XCTAssertNil(regex.firstMatch(in: string))
	}

	func testEnumeratingMatches() throws {
		let string = "abc"
		let pattern = "[b0]"
		let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
		var rangeOfFirstMatch: Range<String.Index>?
		regex.enumerateMatches(in: string) { result, _, _ in
			guard let result else {
				return
			}
			rangeOfFirstMatch = result.range(in: string)
			XCTAssertEqual(result.range(in: string), string.range(of: "b"))
		}
		XCTAssertEqual(rangeOfFirstMatch, regex.rangeOfFirstMatch(in: string))
	}

}
