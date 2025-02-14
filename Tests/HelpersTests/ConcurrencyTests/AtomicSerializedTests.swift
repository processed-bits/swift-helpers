// AtomicSerializedTests.swift, 12.04.2023-12.02.2025.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

import Helpers
import Testing

struct AtomicSerializedTests {

	private let iterations = 100_000

	@Test func strict() {
		let stopwatch = Stopwatch()
		defer { print("AtomicSerialized strict test completed in \(stopwatch).") }

		@AtomicSerialized var indices: [Int] = []
		@AtomicSerialized var counter = 0

		for index in 0 ..< iterations {
			_indices.mutatingBlock { indices in
				indices.append(index)
			}
			_counter.mutatingBlock { counter in
				counter += 1
			}
		}

		// Assert that the number of indices and the counter value equal iterations.
		#expect(indices.count == iterations)
		#expect(counter == iterations)

		// Assert than indices were added sequentially, thus have strict order.
		let isOrderStrict = !indices.enumerated().contains { index, storedIndex in
			index != storedIndex
		}
		#expect(isOrderStrict)
	}

}
