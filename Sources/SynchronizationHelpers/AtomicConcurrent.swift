// AtomicConcurrent.swift, 09.03.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

import Foundation

/// A property wrapper that provides thread-safe access to a value using a concurrent queue, allowing concurrent reads and using barriers to ensure exclusive writes.
///
/// Suitable when read operations are frequent and write operations are less frequent.
///
/// - Note: Prefer ``AtomicSerial`` when most operations modify value, a concurrent queue does not provide significant benefits, and barriers add overhead.
///
/// See [Synchronization Helpers](<doc:SynchronizationHelpers>) for more information.
@propertyWrapper
public final class AtomicConcurrent<Value>: @unchecked Sendable {

	private var value: Value
	private let queue: DispatchQueue

	/// Initializes the property wrapper with an initial value.
	///
	/// - Parameters:
	///   - wrappedValue: The initial value to store.
	///   - qos: The quality of service, or the execution priority, to apply to tasks.
	public init(wrappedValue: Value, qos: DispatchQoS = .default) {
		value = wrappedValue

		var label = String(describing: Self.self)
		if let bundleIdentifier = Bundle.main.bundleIdentifier {
			label = "\(bundleIdentifier).\(label)"
		}

		queue = DispatchQueue(
			label: label,
			qos: qos,
			attributes: .concurrent,
			target: .global(qos: qos.qosClass)
		)
	}

	/// The wrapped value, accessed in a thread-safe manner.
	public var wrappedValue: Value {
		get { queue.sync { value } }
		set { queue.sync(flags: .barrier) { value = newValue } }
	}

	/// The projected value representing the property wrapper itself.
	public var projectedValue: AtomicConcurrent<Value> { self }

	/// Calls the given closure on the value in a thread-safe manner and returns a result, if any.
	@discardableResult public func withLock<R>(_ body: (inout Value) throws -> R) rethrows -> R {
		try queue.sync(flags: .barrier) { try body(&value) }
	}

}
