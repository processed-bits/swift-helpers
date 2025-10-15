// SplitStopwatchTests.swift, 22.04.2023.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

#if !os(Linux)
	import DebuggingHelpers
	import Foundation
	import Testing
	import TestingShared

	@Suite(.tags(.performance)) struct SplitStopwatchTests {

		@Test func splitStopwatch() throws {
			let iterations = 10
			let interval: TimeInterval = 0.1
			let totalInterval = interval * Double(iterations)
			let tolerance = 1.1

			let stopwatch = SplitStopwatch()
			defer { debugPrint(stopwatch) }

			for iteration in 1 ... iterations {
				// Sleep for iteration interval.
				sleep(for: .seconds(interval))

				let shouldSplit = iteration < iterations
				if shouldSplit {
					// Split the lap.
					stopwatch.split()

					// Start and stop randomly between some laps.
					if Bool.random() {
						stopwatch.stop()
						sleep(for: .seconds(interval))
						stopwatch.start()
					}
				} else {
					stopwatch.stop()
				}
			}

			let expectedLapMeasurement = interval ... interval * tolerance
			withKnownIssue(.performance, isIntermittent: true) {
				for lap in stopwatch.laps {
					#expect(expectedLapMeasurement ~= lap.measurement.value)
				}
			}

			let expectedMeasurement = totalInterval ... totalInterval * tolerance
			withKnownIssue(.performance, isIntermittent: true) {
				#expect(expectedMeasurement ~= stopwatch.measurement.value)
			}
		}

	}
#endif
