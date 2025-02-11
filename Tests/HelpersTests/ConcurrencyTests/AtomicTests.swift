// AtomicTests.swift, 12.04.2023-05.04.2024.
// Copyright © 2023-2024 Stanislav Lomachinskiy.

import Helpers
import XCTest

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class AtomicTests: XCTestCase {

	private let iterations = 100_000

	@Atomic private var indices: [Int] = []
	@Atomic private var counter = 0

	func test() async {
		await withTaskGroup(of: Void.self) { taskGroup in
			for index in 0 ..< iterations {
				taskGroup.addTask { [self] in
					_indices.mutatingBlock { indices in
						indices.append(index)
					}
				}
				taskGroup.addTask { [self] in
					_counter.mutatingBlock { counter in
						counter += 1
					}
				}
			}
			await taskGroup.waitForAll()
		}

		// Assert that number of indices equals iterations.
		XCTAssertEqual(indices.count, iterations)

		// Assert than indices were added concurrently, thus have relaxed order.
		let isOrderRelaxed = indices.enumerated().contains { index, storedIndex in
			index != storedIndex
		}
		XCTAssert(isOrderRelaxed)

		// Assert that counter equals iterations.
		XCTAssertEqual(counter, iterations)
	}

}
