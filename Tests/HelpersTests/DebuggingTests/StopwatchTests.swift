// StopwatchTests.swift, 06.03.2023-10.04.2024.
// Copyright © 2023-2024 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class StopwatchTests: XCTestCase {

	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	func test() async throws {
		let stopwatch = Stopwatch()
		defer { print("Sleep: \(stopwatch)") }

		let interval: TimeInterval = 0.1
		let iterations = 10
		for _ in 1 ... iterations {
			stopwatch.start()
			try await Task.sleep(for: .seconds(interval))
			stopwatch.stop()
		}

		let totalInterval = interval * Double(iterations)
		XCTAssertGreaterThan(stopwatch.measurement.value, totalInterval)
		XCTAssertEqual(stopwatch.measurement.value, totalInterval, accuracy: totalInterval * 0.05)
	}

}
