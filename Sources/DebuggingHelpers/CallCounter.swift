// CallCounter.swift, 11.01.2021.
// Copyright © 2021-2025 Stanislav Lomachinskiy.

import Foundation
import SynchronizationHelpers

/// Tracks the number of calls (invocations) or their balance.
public class CallCounter: @unchecked Sendable, CustomStringConvertible {

	/// The expected number of calls.
	public let expectedCount: Int?
	/// The current number of calls.
	@AtomicSerial public private(set) var count: Int = 0

	/// Creates a counter.
	///
	/// - Parameters:
	///   - expectedCount: The expected number of calls, if any.
	public init(expectedCount: Int? = nil) {
		self.expectedCount = expectedCount
	}

	/// Increments the count by one.
	public func increment() {
		_count.withLock { $0 += 1 }
	}

	/// Decrements the count by one.
	public func decrement() {
		_count.withLock { $0 -= 1 }
	}

	/// A description with the count of calls.
	public var description: String {
		if #available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *) {
			if let expectedCount {
				"\(count.formatted()) of \(expectedCount.formatted())"
			} else {
				count.formatted()
			}
		} else {
			if let expectedCount {
				String.localizedStringWithFormat("%d of %d", count, expectedCount)
			} else {
				String.localizedStringWithFormat("%d", count)
			}
		}
	}

}

// MARK: - Deprecated

@available(*, deprecated, renamed: "CallCounter")
public typealias CallsCounter = CallCounter
