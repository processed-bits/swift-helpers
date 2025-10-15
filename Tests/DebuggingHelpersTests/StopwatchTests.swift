// StopwatchTests.swift, 06.03.2023.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

#if !os(Linux)
	import DebuggingHelpers
	import Foundation
	import Testing
	import TestingShared

	@Suite(.tags(.performance)) struct StopwatchTests {

		@Test func stopwatch() throws {
			let iterations = 10
			let interval: TimeInterval = 0.1
			let totalInterval = interval * Double(iterations)
			let tolerance = 1.1

			let stopwatch = Stopwatch()
			defer { debugPrint(stopwatch) }

			for _ in 1 ... iterations {
				stopwatch.start()
				// Sleep for iteration interval.
				sleep(for: .seconds(interval))
				stopwatch.stop()
			}

			let expectedMeasurement = totalInterval ... totalInterval * tolerance
			withKnownIssue(.performance, isIntermittent: true) {
				#expect(expectedMeasurement ~= stopwatch.measurement.value)
			}
		}

	}
#endif
