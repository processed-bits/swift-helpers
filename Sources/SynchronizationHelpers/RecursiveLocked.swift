// RecursiveLocked.swift, 10.03.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

import Foundation

/// A property wrapper that provides thread-safe access to a value using `NSRecursiveLock`.
///
/// See [Synchronization Helpers](<doc:SynchronizationHelpers>) and [`NSRecursiveLock`](https://developer.apple.com/documentation/foundation/nsrecursivelock) for more information.
@propertyWrapper
public final class RecursiveLocked<Value>: @unchecked Sendable {

	private var value: Value
	private let lock = NSRecursiveLock()

	/// Initializes the property wrapper with an initial value.
	public init(wrappedValue: Value) {
		value = wrappedValue
	}

	/// The wrapped value, accessed in a thread-safe manner.
	public var wrappedValue: Value {
		get { lock.withLock { value } }
		set { lock.withLock { value = newValue } }
	}

	/// The projected value representing the property wrapper itself.
	public var projectedValue: RecursiveLocked<Value> { self }

	/// Calls the given closure on the value in a thread-safe manner and returns a result, if any.
	@discardableResult public func withLock<R>(_ body: (inout Value) throws -> R) rethrows -> R {
		try lock.withLock { try body(&value) }
	}

}
