// CallCounterTests.swift, 11.02.2023.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

import DebuggingHelpers
import Foundation
import StandardLibraryHelpers
import Testing

struct CallCounterTests {

	// MARK: Calls Count

	private let iterations = 10_000

	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	@Test func countWithTaskGroup() async {
		let callCounter = CallCounter(expectedCount: iterations)
		let threadCounter = ThreadCounter()
		await withTaskGroup(of: Void.self) { taskGroup in
			for _ in 0 ..< iterations {
				taskGroup.addTask {
					callCounter.increment()
					threadCounter.add()
				}
			}
		}

		let pairs: KeyValuePairs<String, Any> = [
			"Calls": callCounter,
			"Threads": threadCounter,
		]
		print(pairs.formatted(keySuffix: ":"))
		#expect(callCounter.count == callCounter.expectedCount)
	}

	@Test func countWithDispatchQueue() {
		let callCounter = CallCounter(expectedCount: iterations)
		let threadCounter = ThreadCounter()
		DispatchQueue.concurrentPerform(iterations: iterations) { _ in
			callCounter.increment()
			threadCounter.add()
		}

		let pairs: KeyValuePairs<String, Any> = [
			"Calls": callCounter,
			"Threads": threadCounter,
		]
		print(pairs.formatted(keySuffix: ":"))
		#expect(callCounter.count == callCounter.expectedCount)
	}

	@Test func countWithOperationQueue() {
		let callCounter = CallCounter(expectedCount: iterations)
		let threadCounter = ThreadCounter()
		let operationQueue = OperationQueue()
		for _ in 0 ..< iterations {
			operationQueue.addOperation {
				callCounter.increment()
				threadCounter.add()
			}
		}
		operationQueue.waitUntilAllOperationsAreFinished()

		let pairs: KeyValuePairs<String, Any> = [
			"Calls": callCounter,
			"Threads": threadCounter,
		]
		print(pairs.formatted(keySuffix: ":"))
		#expect(callCounter.count == callCounter.expectedCount)
	}

	// MARK: Balance Count

	@Test func balanceCount() {
		let callCounter = CallCounter()
		var object: BalanceMockObject? = BalanceMockObject(callCounter: callCounter)
		// Read from variable to silence compiler warning.
		_ = object
		object = nil

		print("Balance: \(callCounter).")
		// swiftlint:disable:next empty_count
		#expect(callCounter.count == 0)
	}

}

// MARK: - Supporting Types

private class BalanceMockObject {
	private unowned let callCounter: CallCounter

	init(callCounter: CallCounter) {
		self.callCounter = callCounter
		callCounter.increment()
	}

	deinit {
		callCounter.decrement()
	}
}
