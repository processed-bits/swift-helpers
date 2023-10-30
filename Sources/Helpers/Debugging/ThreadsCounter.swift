// ThreadsCounter.swift, 11.01.2021-13.04.2023.
// Copyright © 2021-2023 Stanislav Lomachinskiy.

import Foundation

/// Count and list threads for debugging of concurrent code.
public class ThreadsCounter {

	/// Numbers of used threads.
	@Atomic public private(set) var numbers: Set<Int> = []
	/// Count of used threads.
	public var count: Int { numbers.count }

	/// Creates a counter.
	public init() {}

	/// Adds a thread.
	public func add() {
		guard let number = Thread.current.number else {
			return
		}
		_numbers.mutatingBlock { numbers in
			numbers.update(with: number)
		}
	}

}

extension ThreadsCounter: CustomStringConvertible {

	/// A description with the count and numbers of used threads.
	public var description: String {
		var threadsDescription = "\(count)"
		if !numbers.isEmpty {
			let list = numbers.sorted()
			threadsDescription += " \(list)"
		}
		return threadsDescription
	}

}
