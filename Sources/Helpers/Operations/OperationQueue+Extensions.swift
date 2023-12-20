// OperationQueue+Extensions.swift, 21.10.2019-20.12.2023.
// Copyright © 2019-2023 Stanislav Lomachinskiy.

import Foundation

public extension OperationQueue {

	// MARK: Creating an Operation Queue

	/// Creates a `OperationQueue` object.
	///
	/// - Parameters:
	///   - qos: The default service level to apply to operations that the queue invokes.
	///   - maxConcurrentOperationCount: The maximum number of queued operations that can run at the same time.
	convenience init(qos: QualityOfService? = nil, maxConcurrentOperationCount: Int? = nil) {
		self.init()
		if let qos {
			qualityOfService = qos
		}
		if let maxConcurrentOperationCount {
			self.maxConcurrentOperationCount = maxConcurrentOperationCount
		}
	}

	// MARK: Managing Operations

	/// Wraps the specified block in an operation and adds it to the receiver.
	///
	/// - Parameters:
	///   - block: The block to add to the receiver’s list. The block takes one parameter (weak reference to the `BlockOperation` itself) and have no return value.
	func addOperation(_ block: @escaping @Sendable (BlockOperation?) -> Void) {
		let operation = BlockOperation(block: block)
		addOperation(operation)
	}

}
