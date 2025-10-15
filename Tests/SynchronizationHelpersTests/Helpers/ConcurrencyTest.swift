// ConcurrencyTest.swift, 12.03.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

#if !os(Linux)
	import DebuggingHelpers
	import StandardLibraryHelpers
	import Testing

	/// A base for concurrency property wrappers tests. All tests are benchmarked.
	///
	/// Conform to the protocol and invoke `runTestsAndBenchmark()` from a test method.
	///
	/// - Note: The tests should be run without parallelization for a proper comparison of benchmark results.
	protocol ConcurrencyTest {
		var typeDescription: String { get }

		/// Tests incrementing a non-wrapped counter using a single thread.
		func counterNonWrapped() -> Stopwatch
		/// Tests incrementing a wrapped counter using a single thread.
		func counterWrapped() -> Stopwatch
		/// Tests incrementing a wrapped counter using multiple threads.
		func counterWrappedConcurrent() -> Stopwatch
		/// Tests populating a non-wrapped array using a single thread.
		func arrayNonWrapped() -> Stopwatch
		/// Tests populating a wrapped array using a single thread.
		func arrayWrapped() -> Stopwatch
		/// Tests populating a wrapped array using multiple threads.
		func arrayWrappedConcurrent() -> Stopwatch
	}

	extension ConcurrencyTest {

		var iterations: Int { 100_000 }

		// MARK: Running Tests & Benchmark

		/// Invokes wrapper tests: without a wrapper (defined in the protocol extension) and with a wrapper (defined by the protocol).
		func runTestsAndBenchmark() {
			let pairs: KeyValuePairs<String, Any> = [
				"Wrapper": typeDescription,
				"Counter non-wrapped": counterNonWrapped(),
				"Counter single thread": counterWrapped(),
				"Counter multithreaded": counterWrappedConcurrent(),
				"Array non-wrapped": arrayNonWrapped(),
				"Array single thread": arrayWrapped(),
				"Array multithreaded": arrayWrappedConcurrent(),
			]
			print(pairs.formatted(keySuffix: ":"))
		}

		// MARK: Non-Wrapper Tests

		func counterNonWrapped() -> Stopwatch {
			var counter = 0

			let stopwatch = Stopwatch()
			for _ in 0 ..< iterations {
				counter += 1
			}
			stopwatch.stop()
			#expect(counter == iterations)

			return stopwatch
		}

		func arrayNonWrapped() -> Stopwatch {
			var indices: [Int] = []

			let stopwatch = Stopwatch()
			for index in 0 ..< iterations {
				indices.append(index)
			}
			stopwatch.stop()
			#expect(indices.count == iterations)

			return stopwatch
		}

	}
#endif
