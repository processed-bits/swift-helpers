// SplitStopwatchTests.swift, 22.04.2023-05.04.2024.
// Copyright © 2023-2024 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class SplitStopwatchTests: XCTestCase {

	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	func test() async throws {
		let stopwatch = SplitStopwatch()
		defer { debugPrint(stopwatch) }

		let interval: TimeInterval = 0.1
		let iterations = 5
		for iteration in 1 ... iterations {
			try await Task.sleep(for: .seconds(interval))
			let isSplitIteration = iteration < iterations
			if isSplitIteration {
				stopwatch.split()
				// Randomly pause the stopwatch.
				if Bool.random() {
					stopwatch.stop()
					try await Task.sleep(for: .seconds(interval))
					stopwatch.start()
				}
			} else {
				stopwatch.stop()
			}
		}

		let totalInterval = interval * Double(iterations)
		XCTAssertGreaterThan(stopwatch.result, totalInterval)
		XCTAssertEqual(stopwatch.result, totalInterval, accuracy: totalInterval * 0.05)
		for lap in stopwatch.laps {
			XCTAssertEqual(lap.result, interval, accuracy: interval * 0.1)
		}
	}

}
