// SequenceTests.swift, 19.08.2022-05.05.2023.
// Copyright © 2022-2023 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class SequenceTests: XCTestCase {

	func testCompacted() {
		XCTAssertEqual(
			["A", nil, "B", "C", nil].compacted(),
			["A", "B", "C"]
		)
		XCTAssertEqual(
			[1, nil, 2, 3, nil].compacted(),
			[1, 2, 3]
		)
	}

}
