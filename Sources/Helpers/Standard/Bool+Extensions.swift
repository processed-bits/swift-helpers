// Bool+Extensions.swift, 01.02.2022-01.05.2023.
// Copyright © 2022-2023 Stanislav Lomachinskiy.

import Foundation

/// Back-deployed `toggle()`.
public extension Bool {

	// MARK: Transforming a Boolean

	/// Toggles the Boolean variable’s value.
	///
	/// Use this method to toggle a Boolean value from `true` to `false` or from `false` to `true`.
	@backDeployed(before: iOS 8.0, macOS 10.10, tvOS 9.0, watchOS 2.0)
	@inlinable mutating func toggle() {
		// swiftlint:disable:next toggle_bool
		self = !self
	}

}
