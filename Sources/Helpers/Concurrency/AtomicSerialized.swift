// AtomicSerialized.swift, 29.02.2020-12.02.2025.
// Copyright © 2020-2025 Stanislav Lomachinskiy.

import Foundation

/// A property wrapper that ensures fully serialized, thread-safe access to a value.
///
/// This wrapper is helpful when it is not possible to use other means of serializing access like Swift concurrency or actors.
///
/// The wrapper uses a private serial queue, that targets an underlying global queue, and synchronized read and write operations. If the code **both reads and writes** the value, it is **mandatory** to wrap the code in a mutating block using the underscore syntax to refer to the property wrapper itself:
///
/// ```swift
/// @AtomicSerialized var count: Int = 0
/// _count.mutatingBlock { $0 += 1 }
///
/// @AtomicSerialized var numbers: [Int] = []
/// _numbers.mutatingBlock { numbers in
///     numbers.append(42)
/// }
/// ```
@propertyWrapper
public class AtomicSerialized<Value>: @unchecked Sendable {

	let queue: DispatchQueue
	private var value: Value

	/// Initializes the property wrapper with an initial value.
	///
	/// - Parameters:
	///   - wrappedValue: The initial value to store.
	///   - qos: The quality-of-service level to use with the underlying global queue. This value determines the priority at which the system schedules tasks for execution.
	public init(wrappedValue: Value, qos: DispatchQoS.QoSClass = .unspecified) {
		var label = String(describing: Self.self)
		if let bundleIdentifier = Bundle.main.bundleIdentifier {
			label = "\(bundleIdentifier).\(label)"
		}
		queue = DispatchQueue(label: label, target: .global(qos: qos))
		value = wrappedValue
	}

	/// The wrapped value, accessed in a thread-safe manner.
	public var wrappedValue: Value {
		get { queue.sync { value } }
		set { queue.sync { value = newValue } }
	}

	/// Performs a thread-safe, atomic modification of the value.
	///
	/// See ``AtomicSerialized`` for more information.
	public func mutatingBlock(_ block: (inout Value) -> Void) {
		queue.sync {
			block(&value)
		}
	}

}
