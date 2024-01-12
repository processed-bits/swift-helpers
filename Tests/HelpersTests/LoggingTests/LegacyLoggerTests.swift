// LegacyLoggerTests.swift, 11.02.2023-25.04.2023.
// Copyright © 2023 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class LegacyLoggerTests: XCTestCase {

	private let type = "Helpers.LegacyLogger"

	func testType() {
		let reflection = String(reflecting: LegacyLogger.self)
		print("Reflection: \(reflection)")
		XCTAssertEqual(reflection, type)
	}

	func testPoint() {
		LegacyLogger.default.point()
	}

}
