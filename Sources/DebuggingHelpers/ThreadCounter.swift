// ThreadCounter.swift, 11.01.2021.
// Copyright © 2021-2025 Stanislav Lomachinskiy.

import Foundation
import SynchronizationHelpers

/// Tracks threads for concurrent code debugging.
public class ThreadCounter: @unchecked Sendable {

	/// The descriptions of the added threads.
	@AtomicSerial public private(set) var entries: Set<String> = []

	/// Creates a thread counter.
	public init() {}

	/// Adds the current thread to the counter.
	public func add() {
		// Pass the description of the current thread.
		let description = Thread.current.description
		_entries.withLock { $0.insert(description) }
	}

	/// The count of the added threads.
	public var count: Int { entries.count }

	private var list: [String] {
		// Use standard compare to account for numbers represented as strings.
		entries
			.map {
				// Prefer thread number over memory address.
				if let number = Thread.number(from: $0) {
					return String(number)
				}
				// If memory address is not available, return `?`.
				return Thread.memoryAddress(from: $0) ?? "?"
			}
			.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
	}

}

extension ThreadCounter: CustomStringConvertible {

	/// A description of the used threads.
	public var description: String {
		var output = "\(count)"

		guard !entries.isEmpty else {
			return output
		}

		output += " [" + list.joined(separator: ", ") + "]"
		return output
	}

}

// MARK: - Deprecated

@available(*, deprecated, renamed: "ThreadCounter")
public typealias ThreadsCounter = ThreadCounter
