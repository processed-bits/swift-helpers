// CallsCounterTests.swift, 11.02.2023-23.03.2024.
// Copyright © 2023-2024 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class CallsCounterTests: XCTestCase {

	// MARK: Calls Count

	private let iterations = 10_000

	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	func testExpectedCountWithTaskGroup() async {
		let callsCounter = CallsCounter(expectedCount: iterations)
		let threadsCounter = ThreadsCounter()
		await withTaskGroup(of: Void.self) { taskGroup in
			for _ in 0..<iterations {
				taskGroup.addTask {
					callsCounter.increment()
					threadsCounter.add()
				}
			}
		}

		print("Calls: \(callsCounter).")
		print("Threads: \(threadsCounter).")
		XCTAssertEqual(callsCounter.count, callsCounter.expectedCount)
	}

	func testExpectedCountWithDispatchQueue() {
		let callsCounter = CallsCounter(expectedCount: iterations)
		let threadsCounter = ThreadsCounter()
		DispatchQueue.concurrentPerform(iterations: iterations) { _ in
			callsCounter.increment()
			threadsCounter.add()
		}

		print("Calls: \(callsCounter).")
		print("Threads: \(threadsCounter).")
		XCTAssertEqual(callsCounter.count, callsCounter.expectedCount)
	}

	func testExpectedCountWithOperationQueue() {
		let callsCounter = CallsCounter(expectedCount: iterations)
		let threadsCounter = ThreadsCounter()
		let operationQueue = OperationQueue()
		for _ in 0..<iterations {
			operationQueue.addOperation {
				callsCounter.increment()
				threadsCounter.add()
			}
		}
		operationQueue.waitUntilAllOperationsAreFinished()

		print("Calls: \(callsCounter).")
		print("Threads: \(threadsCounter).")
		XCTAssertEqual(callsCounter.count, callsCounter.expectedCount)
	}

	// MARK: Balance Count

	func testBalanceCount() {
		let callsCounter = CallsCounter()
		var object: BalanceMockObject? = BalanceMockObject(callsCounter: callsCounter)
		// Read from variable to silence compiler warning.
		_ = object
		object = nil

		print("Balance: \(callsCounter).")
		XCTAssertEqual(callsCounter.count, 0)
	}

}

// MARK: - Supporting Types

private class BalanceMockObject {
	private unowned let callsCounter: CallsCounter

	init(callsCounter: CallsCounter) {
		self.callsCounter = callsCounter
		callsCounter.increment()
	}

	deinit {
		callsCounter.decrement()
	}
}
