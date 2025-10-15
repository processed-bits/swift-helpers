// UnfairLockedTests.swift, 10.03.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

#if !os(Linux)
	import DebuggingHelpers
	import Foundation
	import SynchronizationHelpers
	import Testing
	import TestingShared

	@Suite(.tags(.concurrency)) struct UnfairLockedTests: ConcurrencyTest {

		@available(iOS 16.0, macCatalyst 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
		typealias Wrapper = UnfairLocked
		let typeDescription = "UnfairLocked"

		@available(iOS 16.0, macCatalyst 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
		@Test func complex() {
			runTestsAndBenchmark()
		}

		func counterWrapped() -> Stopwatch {
			@Wrapper var counter = 0

			let stopwatch = Stopwatch()
			for _ in 0 ..< iterations {
				$counter.withLock { $0 += 1 }
			}
			stopwatch.stop()
			#expect(counter == iterations)

			return stopwatch
		}

		func counterWrappedConcurrent() -> Stopwatch {
			@Wrapper var counter = 0

			let stopwatch = Stopwatch()
			DispatchQueue.concurrentPerform(iterations: iterations) { _ in
				$counter.withLock { $0 += 1 }
			}
			stopwatch.stop()
			#expect(counter == iterations)

			return stopwatch
		}

		func arrayWrapped() -> Stopwatch {
			@Wrapper var indices: [Int] = []

			let stopwatch = Stopwatch()
			for index in 0 ..< iterations {
				$indices.withLock { $0.append(index) }
			}
			stopwatch.stop()
			#expect(indices.count == iterations)

			return stopwatch
		}

		func arrayWrappedConcurrent() -> Stopwatch {
			@Wrapper var indices: [Int] = []

			let stopwatch = Stopwatch()
			DispatchQueue.concurrentPerform(iterations: iterations) { index in
				$indices.withLock { $0.append(index) }
			}
			stopwatch.stop()
			#expect(indices.count == iterations)

			return stopwatch
		}

	}
#endif
