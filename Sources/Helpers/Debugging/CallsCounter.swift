// CallsCounter.swift, 11.01.2021-10.04.2024.
// Copyright © 2021-2024 Stanislav Lomachinskiy.

/// Count the number or balance of calls (invocations) for debugging of code.
public class CallsCounter: CustomStringConvertible {

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

	/// A description with the count of calls.
	public var description: String {
		if #available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
			if let expectedCount {
				return "\(count.formatted()) of \(expectedCount.formatted())"
			} else {
				return count.formatted()
			}
		} else {
			if let expectedCount {
				return String.localizedStringWithFormat("%d of %d", count, expectedCount)
			} else {
				return String.localizedStringWithFormat("%d", count)
			}
		}
	}

}
