// RegexTests.swift, 12.11.2022-16.11.2022.
// Copyright © 2022 Stanislav Lomachinskiy.

import Helpers
import XCTest

@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
final class RegexTests: XCTestCase {

	func testMatchingStrings() throws {
		let string = "abc"
		let regex = #/[a-z]/#.ignoresCase()
		XCTAssertTrue(regex ~= string)
		XCTAssertEqual(string.matches(of: regex).count, 3)
		XCTAssertNotNil(string.firstMatch(of: regex))
	}

	func testNonMatchingStrings() throws {
		let string = "abc"
		let regex = #/[0-9]/#.ignoresCase()
		XCTAssertFalse(regex ~= string)
		XCTAssertEqual(string.matches(of: regex).count, 0)
		XCTAssertNil(string.firstMatch(of: regex))
	}

}
