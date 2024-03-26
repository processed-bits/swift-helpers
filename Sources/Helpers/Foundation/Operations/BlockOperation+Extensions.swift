// BlockOperation+Extensions.swift, 21.07.2020-20.12.2023.
// Copyright © 2020-2023 Stanislav Lomachinskiy.

import Foundation

/// Helpers for execution blocks with a weak reference to itself.
public extension BlockOperation {

	/// Creates a `BlockOperation` object and adds the specified block to it.
	///
	/// - Parameters:
	///   - block: The block to add to the new block operation object’s list. The block takes one parameter (weak reference to the `BlockOperation` itself) and has no return value.
	convenience init(block: @escaping @Sendable (BlockOperation?) -> Void) {
		self.init()
		addExecutionBlock(block)
	}

	/// Adds the specified block to the receiver’s list of blocks to perform.
	///
	/// The specified block should not make any assumptions about its execution environment.
	///
	/// Calling this method while the receiver is executing or has already finished causes an `NSInvalidArgumentException` exception to be thrown.
	///
	/// - Parameters:
	///   - block: The block to add to the receiver’s list. The block takes one parameter (weak reference to the `BlockOperation` itself) and has no return value.
	func addExecutionBlock(_ block: @escaping @Sendable (BlockOperation?) -> Void) {
		addExecutionBlock { [weak self] in
			block(self)
		}
	}

}
