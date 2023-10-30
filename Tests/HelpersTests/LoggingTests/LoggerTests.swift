// LoggerTests.swift, 15.11.2022-25.04.2023.
// Copyright © 2022-2023 Stanislav Lomachinskiy.

import Helpers
import os.log
import XCTest

final class LoggerTests: XCTestCase {

	private let type = "os.Logger"

	func testType() {
		let reflection = String(reflecting: Logger.self)
		print("Reflection: \(reflection)")
		XCTAssertEqual(reflection, type)
	}

	func testPoint() {
		Logger.default.point()
	}

}
