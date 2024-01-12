// CallsCounter.swift, 11.01.2021-13.04.2023.
// Copyright © 2021-2023 Stanislav Lomachinskiy.

import Foundation

/// Count the number or balance of calls (invocations) for debugging of code.
public class CallsCounter {

	/// Expected number of calls.
	public let expectedCount: Int?
	/// Actual count.
	@Atomic public private(set) var count: Int = 0

	/// Creates a counter.
	///
	/// - Parameters:
	///   - expectedCount: Expected number of calls, if any.
	public init(expectedCount: Int? = nil) {
		self.expectedCount = expectedCount
	}

	/// Increases the count.
	public func increment() {
		_count.mutatingBlock { count in
			count += 1
		}
	}

	/// Decreases the count.
	public func decrement() {
		_count.mutatingBlock { count in
			count -= 1
		}
	}

}

extension CallsCounter: CustomStringConvertible {

	/// A description with the count of calls.
	public var description: String {
		if let expectedCount {
			let format = "%d of %d"
			return String.localizedStringWithFormat(format, count, expectedCount)
		} else {
			let format = "%d"
			return String.localizedStringWithFormat(format, count)
		}
	}

}
