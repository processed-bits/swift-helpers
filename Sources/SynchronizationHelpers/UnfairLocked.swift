// UnfairLocked.swift, 10.03.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

#if canImport(os)
	import os

	/// A property wrapper that provides thread-safe access to a value using `OSAllocatedUnfairLock`.
	///
	/// See [Synchronization Helpers](<doc:SynchronizationHelpers>) and [`OSAllocatedUnfairLock`](https://developer.apple.com/documentation/os/osallocatedunfairlock) for more information.
	@available(iOS 16.0, macCatalyst 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	@propertyWrapper
	public final class UnfairLocked<Value: Sendable>: @unchecked Sendable {

		private var lock: OSAllocatedUnfairLock<Value>

		/// Initializes the property wrapper with an initial value.
		public init(wrappedValue: Value) {
			lock = OSAllocatedUnfairLock(uncheckedState: wrappedValue)
		}

		/// The wrapped value, accessed in a thread-safe manner.
		public var wrappedValue: Value {
			get { lock.withLock { $0 } }
			set { lock.withLock { $0 = newValue } }
		}

		/// The projected value representing the property wrapper itself.
		public var projectedValue: UnfairLocked<Value> { self }

		/// Calls the given closure on the value in a thread-safe manner and returns a result, if any.
		@discardableResult public func withLock<R: Sendable>(_ body: @Sendable (inout Value) throws -> R) rethrows -> R {
			try lock.withLock { try body(&$0) }
		}

	}
#endif
