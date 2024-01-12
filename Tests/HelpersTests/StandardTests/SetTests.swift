// SetTests.swift, 19.08.2022-26.11.2022.
// Copyright © 2022 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class SetTests: XCTestCase {

	func testInitFromString() {
		let set1 = Set(from: "A|B|C", separator: "|")
		let set2 = Set(from: "A, B, C", separator: ",")
		let set3 = Set(from: "A, B, C", separator: ",", trimCharacters: nil)
		let expectedSet = Set(["A", "B", "C"])
		XCTAssertEqual(set1, expectedSet)
		XCTAssertEqual(set2, expectedSet)
		XCTAssertNotEqual(set3, expectedSet)
	}

}
