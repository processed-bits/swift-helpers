// LoggerTests.swift, 15.11.2022-23.03.2024.
// Copyright © 2022-2024 Stanislav Lomachinskiy.

import Helpers
import os.log
import XCTest

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
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
