// LoggerTests.swift, 15.11.2022-12.02.2025.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

#if canImport(os.log)
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
#endif
