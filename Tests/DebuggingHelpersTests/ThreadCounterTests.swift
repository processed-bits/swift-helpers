// ThreadCounterTests.swift, 06.03.2023.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

import DebuggingHelpers
import Foundation
import Testing
import TestingShared

@Suite(.serialized, .tags(.concurrency)) struct ThreadCounterTests {

	private let iterations = 10_000
	private let minThreadCount = min(
		2,
		ProcessInfo.processInfo.activeProcessorCount / 2
	)

	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	@Test func threadsWithTaskGroup() async {
		let threadCounter = ThreadCounter()
		await withTaskGroup(of: Void.self) { taskGroup in
			for _ in 0 ..< iterations {
				taskGroup.addTask {
					threadCounter.add()
				}
			}
		}

		print("Threads: \(threadCounter).")
		withKnownIssue(.concurrency, isIntermittent: true) {
			#expect(threadCounter.count >= minThreadCount)
		}
	}

	@Test func threadsWithDispatchQueue() {
		let threadCounter = ThreadCounter()
		DispatchQueue.concurrentPerform(iterations: iterations) { _ in
			threadCounter.add()
		}

		print("Threads: \(threadCounter).")
		withKnownIssue(.concurrency, isIntermittent: true) {
			#expect(threadCounter.count >= minThreadCount)
		}
	}

	@Test func threadsWithOperationQueue() {
		let threadCounter = ThreadCounter()
		let operationQueue = OperationQueue()
		for _ in 0 ..< iterations {
			operationQueue.addOperation {
				threadCounter.add()
			}
		}
		operationQueue.waitUntilAllOperationsAreFinished()

		print("Threads: \(threadCounter).")
		withKnownIssue(.concurrency, isIntermittent: true) {
			#expect(threadCounter.count >= minThreadCount)
		}
	}

}
