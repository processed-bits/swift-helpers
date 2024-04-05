// ThreadsCounterTests.swift, 06.03.2023-05.04.2024.
// Copyright © 2023-2024 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class ThreadsCounterTests: XCTestCase {

	private let iterations = 10_000

	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	func testWithTaskGroup() async {
		let threadsCounter = ThreadsCounter()
		await withTaskGroup(of: Void.self) { taskGroup in
			for _ in 0 ..< iterations {
				taskGroup.addTask {
					threadsCounter.add()
				}
			}
		}

		print("Threads: \(threadsCounter).")
		let activeProcessorCount = ProcessInfo.processInfo.activeProcessorCount
		XCTAssertGreaterThanOrEqual(threadsCounter.count, activeProcessorCount)
	}

	func testWithDispatchQueue() {
		let threadsCounter = ThreadsCounter()
		DispatchQueue.concurrentPerform(iterations: iterations) { _ in
			threadsCounter.add()
		}

		print("Threads: \(threadsCounter).")
		let activeProcessorCount = ProcessInfo.processInfo.activeProcessorCount
		XCTAssertGreaterThanOrEqual(threadsCounter.count, activeProcessorCount)
	}

	func testWithOperationQueue() {
		let threadsCounter = ThreadsCounter()
		let operationQueue = OperationQueue()
		for _ in 0 ..< iterations {
			operationQueue.addOperation {
				threadsCounter.add()
			}
		}
		operationQueue.waitUntilAllOperationsAreFinished()

		print("Threads: \(threadsCounter).")
		let activeProcessorCount = ProcessInfo.processInfo.activeProcessorCount
		XCTAssertGreaterThanOrEqual(threadsCounter.count, activeProcessorCount)
	}

}
