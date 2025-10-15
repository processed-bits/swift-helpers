// ProcessAsyncTests.swift, 13.04.2023.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

#if os(macOS)
	import DebuggingHelpers
	import Foundation
	import FoundationHelpers
	import Testing
	import TestingShared

	@Suite(.tags(.performance)) struct ProcessAsyncTests {

		/// Asynchronous/synchronous maximum expected performance ratio, with tolerance, averaged over all runs.
		private let maxAverageRatio = 1.15
		private typealias Closure = @Sendable () async throws -> Void

		@Test func performance() async throws {
			let sleepIntervals: [TimeInterval] = [0.1, 0.2, 0.5, 1.0]
			var ratios: [Double] = []

			for sleepInterval in sleepIntervals {
				let ratio = try await performanceRatio(sleepInterval: sleepInterval)
				ratios.append(ratio)
			}

			precondition(!ratios.isEmpty)
			let averageRatio = ratios.reduce(0.0, +) / Double(ratios.count)
			print("Average ratio:", String(format: "%1.3f", averageRatio))

			withKnownIssue(.performance, isIntermittent: true) {
				#expect(
					averageRatio <= maxAverageRatio,
					"Async processes took \(Int(averageRatio * 100)) % of sync processes running time."
				)
			}
		}

		private func performanceRatio(sleepInterval: TimeInterval) async throws -> Double {
			let script = "sleep \(sleepInterval)"

			// Run process synchronously and asynchronously.
			let syncProcessStopwatch = try await benchmark {
				let process = Process(script: script)
				try process.run()
				process.waitUntilExit()
			}
			let asyncProcessStopwatch = try await benchmark {
				let process = Process(script: script)
				try await process.runUntilExit()
			}

			let ratio = asyncProcessStopwatch.measurement.value / syncProcessStopwatch.measurement.value

			let comparisonSign = ratio < 1 ? "<" : ">"
			let resultString = "\(asyncProcessStopwatch) \(comparisonSign) \(syncProcessStopwatch)"
			print("Async vs. sync process: \(resultString).")

			return ratio
		}

		private func benchmark(closure: @escaping Closure) async throws -> Stopwatch {
			let stopwatch = Stopwatch()
			try await closure()
			stopwatch.stop()
			return stopwatch
		}

	}
#endif
