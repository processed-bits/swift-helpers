// ProcessAsyncTests.swift, 13.04.2023-05.04.2024.
// Copyright © 2023-2024 Stanislav Lomachinskiy.

#if os(macOS)
	import Helpers
	import XCTest

	final class ProcessAsyncTests: XCTestCase {

		private typealias ProcessClosure = () async throws -> Void
		private let maxPerformanceRatio = 1.15

		func testPerformance() async throws {
			let coefficients = [1, 2, 5, 10]
			var ratios: [Double] = []
			for coefficient in coefficients {
				let sleepInterval: TimeInterval = Double(coefficient) * 0.1
				let loadIterations = coefficient * 66_666
				let ratio = try await comparePerformance(sleepInterval: sleepInterval, loadIterations: loadIterations)
				ratios.append(ratio)
			}
			let averageRatio = ratios.reduce(0.0) { result, ratio in
				result + ratio
			} / Double(ratios.count)
			print("Average ratio:", String(format: "%1.2f", averageRatio))
			if averageRatio > maxPerformanceRatio {
				XCTFail("Async processes took \(Int(averageRatio * 100)) % of standard processes running time.")
			}
		}

		private func comparePerformance(sleepInterval: TimeInterval, loadIterations: Int) async throws -> Double {
			let script = "sleep \(sleepInterval)"
			// Run process in a standard way and asynchronously.
			let standardStopwatch = try await benchmarkProcess(loadIterations: loadIterations) {
				let process = Process(script: script)
				try process.run()
				process.waitUntilExit()
			}
			let asyncStopwatch = try await benchmarkProcess(loadIterations: loadIterations) {
				let process = Process(script: script)
				try await process.runUntilExit()
			}
			// Check that async performance is not worse than standard. This includes defined tolerance.
			let ratio: Double = asyncStopwatch.result / standardStopwatch.result
			let resultString = "\(asyncStopwatch) \(ratio <= 1 ? "<" : ">") \(standardStopwatch)"
			print("Async vs. standard process: \(resultString).")
			return ratio
		}

		private func benchmarkProcess(loadIterations: Int, _ closure: @escaping ProcessClosure) async throws -> Stopwatch {
			let stopwatch = Stopwatch()
			try await withThrowingTaskGroup(of: Void.self) { taskGroup in
				// Add process task.
				taskGroup.addTask {
					try await closure()
				}
				// Add more tasks.
				for _ in 1 ... loadIterations {
					taskGroup.addTask {
						_ = Bool.random()
					}
				}
				try await taskGroup.waitForAll()
			}
			stopwatch.stop()
			return stopwatch
		}

	}
#endif
