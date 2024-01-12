// Atomic.swift, 29.02.2020-13.04.2023.
// Copyright © 2020-2023 Stanislav Lomachinskiy.

import Foundation

/// `Atomic` property wrapper.
///
/// Use this property wrapper to serialize access to a value using an underlying global queue. It is mostly helpful with collection types and when it is not possible to use concurrency, actors or other means of serializing access.
///
/// When the code both reads and writes the value, it is mandatory to wrap the code in a mutating block using underscore syntax to refer to the property wrapper itself:
///
/// ```swift
/// @Atomic var numbers: [Int] = []
///
/// _numbers.mutatingBlock { numbers in
///     numbers.append(Int.random(in: Int.min...Int.max))
/// }
/// ```
@propertyWrapper
public class Atomic<Value> {

	let queue: DispatchQueue
	private var value: Value

	/// - Parameters:
	///   - qos: The quality-of-service level to use with the underlying global queue. This value determines the priority at which the system schedules tasks for execution.
	public init(wrappedValue: Value, qos: DispatchQoS.QoSClass = .unspecified) {
		var label = String(describing: Self.self)
		if let bundleIdentifier = Bundle.main.bundleIdentifier {
			label = "\(bundleIdentifier).\(label)"
		}
		queue = DispatchQueue(label: label, target: .global(qos: qos))
		value = wrappedValue
	}

	public var wrappedValue: Value {
		get { queue.sync { value } }
		set { queue.sync { value = newValue } }
	}

	public func mutatingBlock(_ block: (inout Value) -> Void) {
		queue.sync {
			block(&value)
		}
	}

}
