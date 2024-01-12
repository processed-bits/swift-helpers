// CGSizeTests.swift, 19.11.2022.
// Copyright © 2022 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class CGSizeTests: XCTestCase {

	func testSizeFromString() {
		let initialSize = CGSize(width: 123, height: 456)
		let correctStrings = [
			"\(initialSize.width)x\(initialSize.height)",
			"\(initialSize.width) x \(initialSize.height)",
			"\(initialSize.width) x  \(initialSize.height)",
			"\(initialSize.width)  x \(initialSize.height)",
			"\(initialSize.width)  x  \(initialSize.height)",
		]
		let incorrectStrings = [
			"\(initialSize.width)",
			"\(initialSize.width)x",
			"\(initialSize.width)x\(initialSize.height)x\(initialSize.width)",
			"x\(initialSize.width)x\(initialSize.height)",
			"\(initialSize.width)x\(initialSize.height)x",
		]
		for string in correctStrings {
			let size = CGSize(string: string)
			XCTAssertEqual(initialSize, size)
		}
		for string in incorrectStrings {
			let size = CGSize(string: string)
			XCTAssertNotEqual(initialSize, size)
		}
	}

}
